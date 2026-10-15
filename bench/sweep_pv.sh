#!/bin/bash
# pirate_v 토션 스프링 스윕: clamp_k (꼭짓점) x pitch_k (C·D). 9개 배관, 기본 fitting.
cd /home/aisl/Capstone_sim && source install/setup.bash
export ROS_DOMAIN_ID=77 IGN_PARTITION=pv_sweep
Y=src/pipe_robot_sim/models/pirate_v/robot.yaml
cp $Y bench/pv_yaml_backup
COURSES="straight elbow45 elbow90 demo elbow45_up elbow45_down elbow90_up elbow90_down demo3d"
for cfg in "0.5 0.0" "1.5 0.0" "4.0 0.0" "1.5 0.5"; do
  set -- $cfg
  sed -i -E "s|^    clamp_k: [0-9.]+|    clamp_k: $1|; s|^    pitch_k: [0-9.]+|    pitch_k: $2|" $Y
  ros2 run pipe_robot_sim bench --models pirate_v --courses $COURSES --fittings "" -o bench/pv_k$1_p$2.csv > bench/pv_k$1_p$2.txt 2>&1
  echo "done clamp_k=$1 pitch_k=$2" >> bench/pv_sweep_status.txt
done
cp bench/pv_yaml_backup $Y
echo ALLDONE >> bench/pv_sweep_status.txt
