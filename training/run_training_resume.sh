#!/bin/bash

echo "MIGLOG: BASH SCRIPT -> Executing prepare.py ..."
#set -e
#python prepare.py

echo ""
echo "MIGLOG: BASH SCRIPT -> Executing detector ..."
cd detector
SAVE_DIR="/datadrive/lung_cancer/sol1/results"
SAVE_DIR_RES=$SAVE_DIR/res
SAVE_DIR_NET3=$SAVE_DIR"/net3"
SAVE_DIR_NET4=$SAVE_DIR"/net4"
eps=100
CUDA_VISIBLE_DEVICES=0,1,2,3,4 python main.py --model res18 -b 12 --epochs $eps --save-dir $SAVE_DIR_RES --workers 24 
echo ""
echo "MIGLOG: BASH SCRIPT -> Executing detector --resume  --test 1"
CUDA_VISIBLE_DEVICES=0,1,2,3,4 python main.py --model res18 -b 16 --resume $SAVE_DIR_RES/$eps.ckpt --test 1 --workers 24
cp $SAVE_DIR_RES/$eps.ckpt ../../model/detector.ckpt

echo ""
echo "MIGLOG: BASH SCRIPT -> Executing classifier ..."
cd ../classifier
python adapt_ckpt.py --model1  net_detector_3 --model2  net_classifier_3  --resume $SAVE_DIR_RES/$eps.ckpt 
CUDA_VISIBLE_DEVICES=0,1,2,3,4 python main.py --model1  net_detector_3 --model2  net_classifier_3 -b 8 -b2 12 --save-dir $SAVE_DIR_NET3 --resume $SAVE_DIR_NET3/start.ckpt --start-epoch 30 --epochs 130
CUDA_VISIBLE_DEVICES=0,1,2,3,4 python main.py --model1  net_detector_3 --model2  net_classifier_4 -b 8 -b2 12 --save-dir $SAVE_DIR_NET4 --resume $SAVE_DIR_NET3/130.ckpt --freeze_batchnorm 1 --start-epoch 121
cp $SAVE_DIR_NET4/160.ckpt ../../model/classifier.ckpt

echo ""
echo "MIGLOG: BASH SCRIPT -> Training process finished"
