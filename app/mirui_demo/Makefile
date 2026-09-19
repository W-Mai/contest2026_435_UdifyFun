############################################################################
# Contest 2026 team 435 (UdifyFun) mirui_demo - Makefile (Rust/Cargo)
############################################################################

include $(APPDIR)/Make.defs

PROGNAME  = mirui_demo
PRIORITY  = SCHED_PRIORITY_DEFAULT
STACKSIZE = 65536
MODULE    = $(CONFIG_LVX_USE_DEMO_CONTEST2026_435_MIRUI_DEMO)

context::
	$(call nuttx_add_rust,mirui_demo,$(APPDIR)/packages/demos/contest2026_435_mirui_demo)

include $(APPDIR)/Application.mk
