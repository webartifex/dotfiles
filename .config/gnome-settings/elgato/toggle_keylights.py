#!/usr/bin/env python

import leglight

LEFT_KEYLIGHT_IP = "192.168.20.72"
RIGHT_KEYLIGHT_IP = "192.168.20.73"

left = leglight.LegLight(LEFT_KEYLIGHT_IP, port=9123)
right = leglight.LegLight(RIGHT_KEYLIGHT_IP, port=9123)

if left.info()["on"] or right.info()["on"]:
    left.off()
    right.off()

else:
    left.on()
    right.on()
    left.brightness(30)
    right.brightness(30)
    left.color(6000)
    right.color(6000)
