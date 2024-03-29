# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.runs/synth_1/RiscDiag_CanFd.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param chipscope.maxJobs 2
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.cache/wt [current_project]
set_property parent.project_path C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part_repo_paths {C:/Users/cosmi/AppData/Roaming/Xilinx/Vivado/2022.1/xhub/board_store/xilinx_board_store} [current_project]
set_property board_part digilentinc.com:nexys-a7-100t:part0:1.2 [current_project]
set_property ip_output_repo c:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_mem C:/Users/cosmi/RiscDiag_CanFd/zRepo/RiscDiagCanFd_Srcs/ProgramMemory/instruction_mem.mem
read_verilog -library xil_defaultlib {
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/CanFdDiagnoseModule/CanUdpBridge.v
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/UART_Debug/CommandTranslator.v
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/UART_Debug/Debugger.v
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/Other/SevenSegDisplay.v
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/UART_Debug/UWORDsender.v
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/UART_Debug/UartDebugger.v
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/RiscCanFd_CPU/RiscV_Modules/canfd_unit.v
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/RiscCanFd_CPU/RiscV_Modules/shift_module.v
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/UART_Debug/uart.v
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/UART_Debug/uart_rx.v
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/UART_Debug/uart_tx.v
}
read_vhdl -library xil_defaultlib {
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/CanFdDiagnoseModule/DiagnoseModule.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/Other/common.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/RiscCanFd_CPU/RiscV_Modules/register_file.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/RiscCanFd_CPU/RiscV_Modules/alu.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/RiscCanFd_CPU/RiscV_Modules/control_unit.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/RiscCanFd_CPU/RiscV_Modules/alu_control.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/RiscCanFd_CPU/RiscV_Modules/cfd_control.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/RiscCanFd_CPU/RisCanFdCPU.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/ProgramMemory/program_memory.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/DataMemory/data_memory.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/RiscDiag_CanFd.vhd
}
read_vhdl -library ctu_can_fd_rtl {
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/memory_registers/generated/access_signaler.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/memory_registers/generated/address_decoder.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/packages/can_fd_frame_format.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/packages/id_transfer_pkg.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/packages/can_constants_pkg.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/packages/can_config_pkg.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/packages/can_types_pkg.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/packages/drv_stat_pkg.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/packages/unary_ops_pkg.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/packages/can_fd_register_map.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/dff_arst.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/dff_arst_ce.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/bit_destuffing.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/bus_sampling/bit_err_detector.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/frame_filters/bit_filter.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/prescaler/bit_segment_meter.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/bit_stuffing.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/prescaler/bit_time_cfg_capture.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/prescaler/bit_time_counters.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/prescaler/bit_time_fsm.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/sig_sync.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/mux2.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/bus_sampling/trv_delay_meas.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/bus_sampling/data_edge_detector.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/bus_sampling/ssp_generator.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/bus_sampling/tx_data_cache.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/bus_sampling/sample_mux.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/bus_sampling/bus_sampling.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/bus_traffic_counters.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/endian_swapper.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/dlc_decoder.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/protocol_control_fsm.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/control_counter.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/reintegration_counter.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/retransmitt_counter.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/err_detector.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/shift_reg_preload.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/tx_shift_reg.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/shift_reg_byte.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/rx_shift_reg.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/protocol_control.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/operation_control.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/fault_confinement_fsm.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/err_counters.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/fault_confinement_rules.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/fault_confinement.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/crc_calc.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/can_crc.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/trigger_mux.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_core/can_core.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/memory_registers/generated/can_registers_pkg.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/rst_sync.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/clk_gate.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/memory_registers/generated/cmn_reg_map_pkg.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/memory_registers/generated/control_registers_reg_map.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/memory_registers/generated/test_registers_reg_map.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/memory_registers/memory_registers.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/rx_buffer/rx_buffer_fsm.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/rx_buffer/rx_buffer_pointers.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/common_blocks/inf_ram_wrapper.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/rx_buffer/rx_buffer_ram.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/rx_buffer/rx_buffer.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/txt_buffer/txt_buffer_ram.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/txt_buffer/txt_buffer_fsm.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/txt_buffer/txt_buffer.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/tx_arbitrator/priority_decoder.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/tx_arbitrator/tx_arbitrator_fsm.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/tx_arbitrator/tx_arbitrator.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/frame_filters/range_filter.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/frame_filters/frame_filters.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/interrupt_manager/int_module.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/interrupt_manager/int_manager.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/prescaler/synchronisation_checker.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/prescaler/segment_end_detector.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/prescaler/trigger_generator.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/prescaler/prescaler.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/can_top_level.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/memory_registers/generated/data_mux.vhd
  C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/CTU_CAN_FD/memory_registers/generated/memory_reg.vhd
}
read_edif C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/sources_1/imports/zRepo/RiscDiagCanFd_Srcs/CanFdDiagnoseModule/FC1001_RMII.edn
OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/constrs_1/imports/RiscDiagCanFd_Srcs/constraints.xdc
set_property used_in_implementation false [get_files C:/Users/cosmi/RiscDiag_CanFd_Repo/RiscDiagCanFd/RiscDiagCanFd.srcs/constrs_1/imports/RiscDiagCanFd_Srcs/constraints.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top RiscDiag_CanFd -part xc7a100tcsg324-1
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef RiscDiag_CanFd.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file RiscDiag_CanFd_utilization_synth.rpt -pb RiscDiag_CanFd_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }
