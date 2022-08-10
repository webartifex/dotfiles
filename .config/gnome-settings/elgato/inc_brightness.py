#!/usr/bin/env python

import leglight

LEFT_KEYLIGHT_IP = "192.168.20.72"
RIGHT_KEYLIGHT_IP = "192.168.20.73"

left = leglight.LegLight(LEFT_KEYLIGHT_IP, port=9123)
right = leglight.LegLight(RIGHT_KEYLIGHT_IP, port=9123)

left.incBrightness(5)
right.incBrightness(5)
