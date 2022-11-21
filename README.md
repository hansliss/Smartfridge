# Salesforce DX Project: Smartfridge
Electric Imp Smartfridge project, with some updates and additions.

The version this is based on uses JWT authentication with a certificate. It creates Platform Events in Salesforce. There are several changes and additions:
* I added a Flow that subscribes to these events and updates a selected Smartfridge. If the door has been left open for long enough, a Case will be created and the owner notified - this is only checked whenever a new update is posted.
* There's a checkbox on the Smartfridge object that decides whether the Flow will create SmartfridgeEvent records on every update.
* The device will only send updates when the values have changed beyond a certain threshold.
* There's also a version of the device code that can update an SSD1306 OLED screen, but since the Imp sleeps between updates, this is somewhat useless.

