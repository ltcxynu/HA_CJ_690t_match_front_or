
Q
Command: %s
53*	vivadotcl2 
route_design2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
	xc7vx690t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
	xc7vx690t2default:defaultZ17-349h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
route_design2default:defaultZ4-22h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
V

Starting %s Task
103*constraints2
Routing2default:defaultZ18-103h px� 
}
BMultithreading enabled for route_design using a maximum of %s CPUs17*	routeflow2
22default:defaultZ35-254h px� 
p

Phase %s%s
101*constraints2
1 2default:default2#
Build RT Design2default:defaultZ18-101h px� 
C
.Phase 1 Build RT Design | Checksum: 10b94e4ab
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:00 ; elapsed = 00:00:37 . Memory (MB): peak = 3939.414 ; gain = 187.6172default:defaulth px� 
v

Phase %s%s
101*constraints2
2 2default:default2)
Router Initialization2default:defaultZ18-101h px� 
o

Phase %s%s
101*constraints2
2.1 2default:default2 
Create Timer2default:defaultZ18-101h px� 
B
-Phase 2.1 Create Timer | Checksum: 10b94e4ab
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:00 ; elapsed = 00:00:37 . Memory (MB): peak = 3939.414 ; gain = 187.6172default:defaulth px� 
{

Phase %s%s
101*constraints2
2.2 2default:default2,
Fix Topology Constraints2default:defaultZ18-101h px� 
N
9Phase 2.2 Fix Topology Constraints | Checksum: 10b94e4ab
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:00 ; elapsed = 00:00:37 . Memory (MB): peak = 3940.219 ; gain = 188.4222default:defaulth px� 
t

Phase %s%s
101*constraints2
2.3 2default:default2%
Pre Route Cleanup2default:defaultZ18-101h px� 
G
2Phase 2.3 Pre Route Cleanup | Checksum: 10b94e4ab
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:00 ; elapsed = 00:00:38 . Memory (MB): peak = 3940.219 ; gain = 188.4222default:defaulth px� 
p

Phase %s%s
101*constraints2
2.4 2default:default2!
Update Timing2default:defaultZ18-101h px� 
C
.Phase 2.4 Update Timing | Checksum: 247894a5f
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:20 ; elapsed = 00:00:53 . Memory (MB): peak = 4117.852 ; gain = 366.0552default:defaulth px� 
�
Intermediate Timing Summary %s164*route2N
:| WNS=-4.340 | TNS=-8325.241| WHS=-0.481 | THS=-2115.113|
2default:defaultZ35-416h px� 
}

Phase %s%s
101*constraints2
2.5 2default:default2.
Update Timing for Bus Skew2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
2.5.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
E
0Phase 2.5.1 Update Timing | Checksum: 1f69a7fc1
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:30 ; elapsed = 00:00:59 . Memory (MB): peak = 4117.852 ; gain = 366.0552default:defaulth px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-4.340 | TNS=-8321.304| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
P
;Phase 2.5 Update Timing for Bus Skew | Checksum: 24d8562e9
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:31 ; elapsed = 00:00:59 . Memory (MB): peak = 4117.852 ; gain = 366.0552default:defaulth px� 
I
4Phase 2 Router Initialization | Checksum: 1f6970b21
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:31 ; elapsed = 00:01:00 . Memory (MB): peak = 4140.625 ; gain = 388.8282default:defaulth px� 
p

Phase %s%s
101*constraints2
3 2default:default2#
Initial Routing2default:defaultZ18-101h px� 
q

Phase %s%s
101*constraints2
3.1 2default:default2"
Global Routing2default:defaultZ18-101h px� 
D
/Phase 3.1 Global Routing | Checksum: 1f6970b21
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:31 ; elapsed = 00:01:00 . Memory (MB): peak = 4140.625 ; gain = 388.8282default:defaulth px� 
C
.Phase 3 Initial Routing | Checksum: 1c9ed7ac5
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:00 ; elapsed = 00:01:15 . Memory (MB): peak = 4140.625 ; gain = 388.8282default:defaulth px� 
s

Phase %s%s
101*constraints2
4 2default:default2&
Rip-up And Reroute2default:defaultZ18-101h px� 
u

Phase %s%s
101*constraints2
4.1 2default:default2&
Global Iteration 02default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-4.679 | TNS=-8914.625| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
H
3Phase 4.1 Global Iteration 0 | Checksum: 28b79ccfc
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:43 ; elapsed = 00:01:41 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
u

Phase %s%s
101*constraints2
4.2 2default:default2&
Global Iteration 12default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-5.738 | TNS=-9565.618| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
H
3Phase 4.2 Global Iteration 1 | Checksum: 1418c6a8e
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:45 ; elapsed = 00:01:43 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
F
1Phase 4 Rip-up And Reroute | Checksum: 1418c6a8e
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:46 ; elapsed = 00:01:43 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
|

Phase %s%s
101*constraints2
5 2default:default2/
Delay and Skew Optimization2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
5.1 2default:default2!
Delay CleanUp2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
5.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
E
0Phase 5.1.1 Update Timing | Checksum: 1ce1363f9
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:48 ; elapsed = 00:01:44 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-4.679 | TNS=-8907.195| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
B
-Phase 5.1 Delay CleanUp | Checksum: b86da1ea
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:49 ; elapsed = 00:01:45 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
z

Phase %s%s
101*constraints2
5.2 2default:default2+
Clock Skew Optimization2default:defaultZ18-101h px� 
L
7Phase 5.2 Clock Skew Optimization | Checksum: b86da1ea
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:49 ; elapsed = 00:01:45 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
N
9Phase 5 Delay and Skew Optimization | Checksum: b86da1ea
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:49 ; elapsed = 00:01:45 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
n

Phase %s%s
101*constraints2
6 2default:default2!
Post Hold Fix2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
6.1 2default:default2!
Hold Fix Iter2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
6.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
D
/Phase 6.1.1 Update Timing | Checksum: 654b53e6
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:52 ; elapsed = 00:01:47 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-4.675 | TNS=-8898.982| WHS=-0.028 | THS=-0.028 |
2default:defaultZ35-416h px� 
C
.Phase 6.1 Hold Fix Iter | Checksum: 20d6110d1
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:52 ; elapsed = 00:01:47 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
A
,Phase 6 Post Hold Fix | Checksum: 1c7f64dad
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:52 ; elapsed = 00:01:47 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
o

Phase %s%s
101*constraints2
7 2default:default2"
Route finalize2default:defaultZ18-101h px� 
B
-Phase 7 Route finalize | Checksum: 2540ff382
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:53 ; elapsed = 00:01:47 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
v

Phase %s%s
101*constraints2
8 2default:default2)
Verifying routed nets2default:defaultZ18-101h px� 
I
4Phase 8 Verifying routed nets | Checksum: 2540ff382
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:53 ; elapsed = 00:01:48 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
r

Phase %s%s
101*constraints2
9 2default:default2%
Depositing Routes2default:defaultZ18-101h px� 
E
0Phase 9 Depositing Routes | Checksum: 1c6b4bfc1
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:55 ; elapsed = 00:01:50 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
t

Phase %s%s
101*constraints2
10 2default:default2&
Post Router Timing2default:defaultZ18-101h px� 
q

Phase %s%s
101*constraints2
10.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
D
/Phase 10.1 Update Timing | Checksum: 1c59c7b03
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:58 ; elapsed = 00:01:52 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
�
Estimated Timing Summary %s
57*route2L
8| WNS=-4.675 | TNS=-8898.982| WHS=0.053  | THS=0.000  |
2default:defaultZ35-57h px� 
B
!Router estimated timing not met.
128*routeZ35-328h px� 
G
2Phase 10 Post Router Timing | Checksum: 1c59c7b03
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:58 ; elapsed = 00:01:52 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
@
Router Completed Successfully
2*	routeflowZ35-16h px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:58 ; elapsed = 00:01:52 . Memory (MB): peak = 4150.828 ; gain = 399.0312default:defaulth px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
5502default:default2
1742default:default2
1132default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
route_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
route_design: 2default:default2
00:03:112default:default2
00:01:592default:default2
4150.8282default:default2
399.0312default:defaultZ17-268h px� 
H
&Writing timing data to binary archive.266*timingZ38-480h px� 
D
Writing placer database...
1603*designutilsZ20-1893h px� 
=
Writing XDEF routing.
211*designutilsZ20-211h px� 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px� 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2)
Write XDEF Complete: 2default:default2
00:00:102default:default2
00:00:032default:default2
4150.8282default:default2
0.0002default:defaultZ17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
xE:/shixi/prj/HA_CJ_690t_match/HA_CJ_690t_match_front_or/HA_CJ_690t_match_front_or.runs/impl_1/SF51_JR6101_top_routed.dcp2default:defaultZ17-1381h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2&
write_checkpoint: 2default:default2
00:00:212default:default2
00:00:122default:default2
4150.8282default:default2
0.0002default:defaultZ17-268h px� 
�
%s4*runtcl2�
�Executing : report_drc -file SF51_JR6101_top_drc_routed.rpt -pb SF51_JR6101_top_drc_routed.pb -rpx SF51_JR6101_top_drc_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
ureport_drc -file SF51_JR6101_top_drc_routed.rpt -pb SF51_JR6101_top_drc_routed.pb -rpx SF51_JR6101_top_drc_routed.rpx2default:defaultZ4-113h px� 
>
IP Catalog is up to date.1232*coregenZ19-1839h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
�
#The results of DRC are in file %s.
586*	vivadotcl2�
|E:/shixi/prj/HA_CJ_690t_match/HA_CJ_690t_match_front_or/HA_CJ_690t_match_front_or.runs/impl_1/SF51_JR6101_top_drc_routed.rpt|E:/shixi/prj/HA_CJ_690t_match/HA_CJ_690t_match_front_or/HA_CJ_690t_match_front_or.runs/impl_1/SF51_JR6101_top_drc_routed.rpt2default:default8Z2-168h px� 
\
%s completed successfully
29*	vivadotcl2

report_drc2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2 
report_drc: 2default:default2
00:00:182default:default2
00:00:092default:default2
4150.8282default:default2
0.0002default:defaultZ17-268h px� 
�
%s4*runtcl2�
�Executing : report_methodology -file SF51_JR6101_top_methodology_drc_routed.rpt -pb SF51_JR6101_top_methodology_drc_routed.pb -rpx SF51_JR6101_top_methodology_drc_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
�report_methodology -file SF51_JR6101_top_methodology_drc_routed.rpt -pb SF51_JR6101_top_methodology_drc_routed.pb -rpx SF51_JR6101_top_methodology_drc_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
Y
$Running Methodology with %s threads
74*drc2
22default:defaultZ23-133h px� 
�
2The results of Report Methodology are in file %s.
609*	vivadotcl2�
�E:/shixi/prj/HA_CJ_690t_match/HA_CJ_690t_match_front_or/HA_CJ_690t_match_front_or.runs/impl_1/SF51_JR6101_top_methodology_drc_routed.rpt�E:/shixi/prj/HA_CJ_690t_match/HA_CJ_690t_match_front_or/HA_CJ_690t_match_front_or.runs/impl_1/SF51_JR6101_top_methodology_drc_routed.rpt2default:default8Z2-1520h px� 
d
%s completed successfully
29*	vivadotcl2&
report_methodology2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2(
report_methodology: 2default:default2
00:00:132default:default2
00:00:082default:default2
4150.8282default:default2
0.0002default:defaultZ17-268h px� 
�
%s4*runtcl2�
�Executing : report_power -file SF51_JR6101_top_power_routed.rpt -pb SF51_JR6101_top_power_summary_routed.pb -rpx SF51_JR6101_top_power_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
�report_power -file SF51_JR6101_top_power_routed.rpt -pb SF51_JR6101_top_power_summary_routed.pb -rpx SF51_JR6101_top_power_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px� 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
5622default:default2
1742default:default2
1132default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
report_power2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
report_power: 2default:default2
00:00:152default:default2
00:00:092default:default2
4150.8282default:default2
0.0002default:defaultZ17-268h px� 
�
%s4*runtcl2
kExecuting : report_route_status -file SF51_JR6101_top_route_status.rpt -pb SF51_JR6101_top_route_status.pb
2default:defaulth px� 
�
%s4*runtcl2�
�Executing : report_timing_summary -max_paths 10 -report_unconstrained -file SF51_JR6101_top_timing_summary_routed.rpt -pb SF51_JR6101_top_timing_summary_routed.pb -rpx SF51_JR6101_top_timing_summary_routed.rpx -warn_on_violation 
2default:defaulth px� 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -2, Delay Type: min_max2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
22default:defaultZ38-191h px� 
�
rThe design failed to meet the timing requirements. Please see the %s report for details on the timing violations.
188*timing2"
timing summary2default:defaultZ38-282h px� 
�
}There are set_bus_skew constraint(s) in this design. Please run report_bus_skew to ensure that bus skew requirements are met.223*timingZ38-436h px� 
�
%s4*runtcl2l
XExecuting : report_incremental_reuse -file SF51_JR6101_top_incremental_reuse_routed.rpt
2default:defaulth px� 
g
BIncremental flow is disabled. No incremental reuse Info to report.423*	vivadotclZ4-1062h px� 
�
%s4*runtcl2l
XExecuting : report_clock_utilization -file SF51_JR6101_top_clock_utilization_routed.rpt
2default:defaulth px� 
�
%s4*runtcl2�
�Executing : report_bus_skew -warn_on_violation -file SF51_JR6101_top_bus_skew_routed.rpt -pb SF51_JR6101_top_bus_skew_routed.pb -rpx SF51_JR6101_top_bus_skew_routed.rpx
2default:defaulth px� 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -2, Delay Type: min_max2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
22default:defaultZ38-191h px� 


End Record