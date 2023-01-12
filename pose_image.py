import argparse
from tflite_runtime.interpreter import Interpreter
import os
import numpy as np
from PIL import Image
from PIL import ImageDraw
from pose_engine import PoseEngine

parser = argparse.ArgumentParser(
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument(
    '-m', '--model', required=True, help='File path of .tflite file.')
parser.add_argument(
    '-i', '--input', required=True, help='Image to be classified.')
parser.add_argument(
    '--output',
    default='movenet_result.jpg',
    help='File path of the output image.')
args = parser.parse_args()

img = Image.open(args.input)
pil_image = img.convert('RGB')
engine = PoseEngine(args.model)
poses, inference_time = engine.DetectPosesInImage(pil_image)

input_shape = engine.get_input_tensor_shape()[1:3]
resized_image = img.resize(
    (input_shape[1], input_shape[0]), Image.NEAREST)
draw = ImageDraw.Draw(resized_image)

print('Inference time: %.f ms' % (inference_time * 1000))
for pose in poses:
    if pose.score < 0.4: continue
    print('\nPose Score: ', pose.score)
    for label, keypoint in pose.keypoints.items():
        print('  %-20s x=%-4d y=%-4d score=%.1f' %
              (label, keypoint.point[0], keypoint.point[1], keypoint.score))
        x, y = keypoint.point
        draw.ellipse((x-2, y-2, x+2, y+2), fill=(0, 255, 0, 0))
resized_image.save(args.output)
print('Done. Results saved at', args.output)