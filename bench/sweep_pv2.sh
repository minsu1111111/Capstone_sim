#!/bin/bash
# pirate_v 재측정 (찌꺼기 시뮬 문제 수정 후). 기준선 = 일정 토크, 나머지 = 꼭짓점 토션 스프링 강성 / C·D 스프링
cd /home/aisl/Capstone_sim && source install/setup.bash
export ROS_DOMAIN_ID=77 IGN_PARTITION=bench
Y=src/pipe_robot_sim/models/pirate_v/robot.yaml
cp $Y bench/pv_yaml_backup2
COURSES="straight elbow45 elbow90 demo elbow45_up elbow45_down elbow90_up elbow90_down demo3d"
rm -f bench/pv2_status.txt
for cfg in "base 0.0 0.0" "k0.5 0.5 0.0" "k1.5 1.5 0.0" "k4.0 4.0 0.0" "k1.5cd 1.5 0.5"; do
  set -- $cfg
  if [ "$2" = "0.0" ]; then
    sed -i -E "s|^    clamp_k: [0-9.]+|    clamp_k: 0.0|; s|^    clamp_torque: .*|    clamp_torque: [0.15, -0.15]|; s|^    pitch_k: [0-9.]+|    pitch_k: 0.0|" $Y
  else
    sed -i -E "s|^    clamp_k: [0-9.]+|    clamp_k: $2|; s|^    clamp_torque: .*|    clamp_torque: [0.0, 0.0]|; s|^    pitch_k: [0-9.]+|    pitch_k: $3|" $Y
  fi
  ros2 run pipe_robot_sim bench --models pirate_v --courses $COURSES --fittings "" -o bench/pv2_$1.csv > bench/pv2_$1.txt 2>&1
  echo "done $1" >> bench/pv2_status.txt
done
cp bench/pv_yaml_backup2 $Y
echo ALLDONE >> bench/pv2_status.txt
