#!/usr/bin/env python3

from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTShadowClient
import random, time

# A random programmatic shadow client ID.
SHADOW_CLIENT = "SsRPiShadowClient"
SHADOW_CLIENT = "SsRPi"

# The unique hostname that AWS IoT generated for 
# this device.
HOST_NAME = "aofc4c78kezrh-ats.iot.eu-west-2.amazonaws.com"

# The relative path to the correct root CA file for AWS IoT, 
# which you have already saved onto this device.
ROOT_CA = "certificates/AmazonRootCA1.pem"

# The relative path to your private key file that 
# AWS IoT generated for this device, which you 
# have already saved onto this device.
PRIVATE_KEY = "certificates/40df25d882-private.pem.key"

# The relative path to your certificate file that 
# AWS IoT generated for this device, which you 
# have already saved onto this device.
CERT_FILE = "certificates/40df25d882-certificate.pem.crt"

# A programmatic shadow handler name prefix.
SHADOW_HANDLER = "SsRPi"

# Automatically called whenever the shadow is updated.
def myShadowUpdateCallback(payload, responseStatus, token):
  print()
  print('UPDATE: $aws/things/' + SHADOW_HANDLER +
    '/shadow/update/#')
  # print("payload = " + payload)
  print("responseStatus = " + responseStatus)
  print("token = " + token)

# Create, configure, and connect a shadow client.
myShadowClient = AWSIoTMQTTShadowClient(SHADOW_CLIENT)
myShadowClient.configureEndpoint(HOST_NAME, 8883)
myShadowClient.configureCredentials(ROOT_CA, PRIVATE_KEY,
  CERT_FILE)
myShadowClient.configureConnectDisconnectTimeout(10)
myShadowClient.configureMQTTOperationTimeout(15)
myShadowClient.connect()

# Create a programmatic representation of the shadow.
myDeviceShadow = myShadowClient.createShadowHandlerWithName(
  SHADOW_HANDLER, True)

# let's send a JSON payload from the argument command line.
import sys
import json
# import datetime

# payload = sys.argv[1]
with open(sys.argv[1]) as f:
    payload = json.load(f)

# dt = datetime.datetime.now()
# payload = '{"state": {"reported": {"date": "%s", "sniff": "%s"}}}' % (
#     dt.strftime("%Y-%m-%dT%H:%M:%S"),
#     # int((dt-datetime.datetime(1970,1,1)).total_seconds()),
#     "payload")
#     # payload)
# payload = '{"state": {"reported": {"serialNumber" : "ABCDEFG12345", "batteryVoltage" : "2000mV", "clickType" : "SINGLE"}}}'
#
# print("payload =", payload)

myDeviceShadow.shadowUpdate(
    # payload,
    '{"state": {"reported": {"sniff": "%s"}}}' % payload,
    myShadowUpdateCallback, 5)

