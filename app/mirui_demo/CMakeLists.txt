# ##############################################################################
# contest2026_435_UdifyFun/app/mirui_demo/CMakeLists.txt
# ##############################################################################

if(CONFIG_LVX_USE_DEMO_CONTEST2026_435_MIRUI_DEMO)

  # Build the Rust crate using the unified Rust registry mechanism
  nuttx_add_rust(CRATE_NAME mirui_demo
                 CRATE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

  nuttx_add_application(
    NAME mirui_demo STACKSIZE 65536 PRIORITY 100)

endif() # CONFIG_LVX_USE_DEMO_CONTEST2026_435_MIRUI_DEMO
