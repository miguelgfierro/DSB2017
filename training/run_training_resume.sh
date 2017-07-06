#!/bin/bash

echo "MIGLOG: BASH SCRIPT -> Executing prepare.py ..."
#set -e
#python prepare.py

echo ""
echo "MIGLOG: BASH SCRIPT -> Executing detector ..."
cd detector
eps=100
CUDA_VISIBLE_DEVICES=0,1,2,3,4 python main.py --model res18 -b 8 --epochs $eps --save-dir res18 --workers 24 
echo ""
echo "MIGLOG: BASH SCRIPT -> Executing detector --resume  --test 1"
CUDA_VISIBLE_DEVICES=0,1,2,3,4 python main.py --model res18 -b 16 --resume results/res18/$eps.ckpt --test 1 --workers 24
cp results/res18/$eps.ckpt ../../model/detector.ckpt

echo ""
echo "MIGLOG: BASH SCRIPT -> Executing classifier ..."
cd ../classifier
python adapt_ckpt.py --model1  net_detector_3 --model2  net_classifier_3  --resume ../detector/results/res18/$eps.ckpt 
CUDA_VISIBLE_DEVICES=0,1,2,3,4 python main.py --model1  net_detector_3 --model2  net_classifier_3 -b 32 -b2 12 --save-dir net3 --resume ./results/start.ckpt --start-epoch 30 --epochs 130
CUDA_VISIBLE_DEVICES=0,1,2,3,4 python main.py --model1  net_detector_3 --model2  net_classifier_4 -b 32 -b2 12 --save-dir net4 --resume ./results/net3/130.ckpt --freeze_batchnorm 1 --start-epoch 121
cp results/net4/160.ckpt ../../model/classifier.ckpt

echo ""
echo "MIGLOG: BASH SCRIPT -> Training process finished"
