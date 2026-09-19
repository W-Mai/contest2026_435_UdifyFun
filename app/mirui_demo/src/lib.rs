/****************************************************************************
 * contest2026_435_UdifyFun/app/mirui_demo/src/lib.rs
 *
 * Port of the mirui no_std ECS-driven UI framework
 * (https://mirui.rs, MIT) to the BEST1700 AOS EVB round screen.
 *
 * Assembly mirrors mirui's own gallery Linux-DRM backend, swapped to
 * the NuttX framebuffer backend: NuttxFbSurface (/dev/fb0 +
 * /dev/input0) + software renderer, then the upstream three-body
 * physics demo takes over the screen.
 *
 * Licensed under the Apache License, Version 2.0.
 ****************************************************************************/

use mirui::app::App;
use mirui::render::SwRendererFactory;
use mirui::surface::nuttx::{NuttxConfig, NuttxFbSurface};
use mirui::ui::builder::WidgetBuilder;

/// NuttX entry point (PROGNAME_main convention).
#[no_mangle]
pub extern "C" fn mirui_demo_main()
{
    /* NuttX framebuffer backend: paths match this EVB (fb0 + touch). */

    let surface = NuttxFbSurface::open(NuttxConfig {
        fb_path: Some("/dev/fb0"),
        touch_path: Some("/dev/input0"),
        ..Default::default()
    })
    .expect("mirui_demo: open /dev/fb0 failed");

    let mut app = App::with_factory(surface, SwRendererFactory::new());
    app.with_default_widgets().with_default_systems();

    /* Upstream three-body physics demo: n-body gravity sim rendered
     * every frame through mirui's software renderer.
     */

    let parent = {
        let world = &mut app.world;
        WidgetBuilder::new(world).id()
    };

    mirui::gallery::demos::three_body::setup_app(&mut app, parent);

    app.set_root(parent);
    app.run();
}
