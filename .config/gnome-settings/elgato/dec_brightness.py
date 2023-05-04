#!/usr/bin/env python

import leglight

LEFT_KEYLIGHT_IP = "192.168.190.62"
RIGHT_KEYLIGHT_IP = "192.168.190.63"

left = leglight.LegLight(LEFT_KEYLIGHT_IP, port=9123)
right = leglight.LegLight(RIGHT_KEYLIGHT_IP, port=9123)

left.decBrightness(5)
right.decBrightness(5)
