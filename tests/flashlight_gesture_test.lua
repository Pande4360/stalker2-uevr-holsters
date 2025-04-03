require("luatest")
local TestHelpers = require("test_helpers")
local FlashlightGesture = require("stalker2.flashlight")
print("\nRunning test suite...")

-- -- Test 1: Both hands near head with grip
RunTest("LH FlashLight Gesture Happy Case", function()
    TestHelpers.resetTestState()
    -- Set up left hand
    local leftHandFlashLight = FlashlightGesture.flashlightGestureLH
    TestHelpers.handStates.left.location = Vector3f.new(0.0, 0.0, 1.7)
    TestHelpers.handStates.left.rotation = Vector3f.new(0, 45, 0)
    TestHelpers.handStates.left.gripActive = false

    TestHelpers.handStates.hmd.location = Vector3f.new(0, 0, 1.7)
    TestHelpers.handStates.hmd.rotation = Vector3f.new(0, 0, 0)

    -- Test right hand head zone
    leftHandFlashLight:Reset()
    local Executed = 0
    leftHandFlashLight:SetExecutionCallback(function(gesture, context)
        print("Left Hand Flashlight Gesture Executed")
        Executed = Executed + 1
    end)

    local actors = require("gestures.motioncontrolleractors")
    actors:Update(TestHelpers.mockEngine)
    leftHandFlashLight:Update({}, {})

    AssertEquals(leftHandFlashLight.isActive, false, "Flashlight gesture should not be active initially")
    AssertEquals(leftHandFlashLight:JustActivated(), false, "Flashlight gesture should not be activated initially")
    
    TestHelpers.handStates.left.gripActive = true
    actors:Update(TestHelpers.mockEngine)
    leftHandFlashLight:Update({}, {})
    AssertEquals(leftHandFlashLight.isActive, true, "Flashlight gesture should be active when grip is pressed")
    AssertEquals(leftHandFlashLight:JustActivated(), true, "Flashlight gesture should be newly activated")

    leftHandFlashLight:Execute({})
    AssertEquals(Executed, 1, "Flashlight gesture callback should have executed")

    leftHandFlashLight:Update({}, {})
    leftHandFlashLight:Execute({})
    AssertEquals(Executed, 2, "callback executing irrsepective of gesture state callback should handle this case internally")

    TestHelpers.handStates.left.location.y = 6.0;
    leftHandFlashLight:Update({}, {})
    leftHandFlashLight:Execute({})
    AssertEquals(leftHandFlashLight.isActive, false, "Flashlight gesture should not be active when out of range")
    AssertEquals(leftHandFlashLight:JustDeactivated(), true, "Flashlight gesture should be deactivated when moving out of range")
    AssertEquals(Executed, 3, "callback executing irrsepective of gesture state callback should handle this case internally")

    leftHandFlashLight:Update({}, {})
    leftHandFlashLight:Execute({})
    AssertEquals(Executed, 4, "callback executing irrsepective of gesture state callback should handle this case internally")

    leftHandFlashLight:SetExecutionCallback(nil) -- Clear the callback to avoid side effects in subsequent tests
    return true
end)

-- Test 2: Right Hand Flashlight Gesture
RunTest("RH FlashLight Gesture Happy Case", function()
    TestHelpers.resetTestState()
    -- Set up right hand
    local rightHandFlashLight = FlashlightGesture.flashlightGestureRH
    TestHelpers.handStates.right.location = Vector3f.new(0.0, 0.0, 1.7)
    TestHelpers.handStates.right.rotation = Vector3f.new(0, 45, 0)
    TestHelpers.handStates.right.gripActive = false

    TestHelpers.handStates.hmd.location = Vector3f.new(0, 0, 1.7)
    TestHelpers.handStates.hmd.rotation = Vector3f.new(0, 0, 0)

    -- Test right hand head zone
    rightHandFlashLight:Reset()
    local Executed = 0
    rightHandFlashLight:SetExecutionCallback(function(gesture, context)
        print("Right Hand Flashlight Gesture Executed")
        Executed = Executed + 1
    end)

    local actors = require("gestures.motioncontrolleractors")
    actors:Update(TestHelpers.mockEngine)
    rightHandFlashLight:Update({}, {})

    AssertEquals(rightHandFlashLight.isActive, false, "Flashlight gesture should not be active initially")
    AssertEquals(rightHandFlashLight:JustActivated(), false, "Flashlight gesture should not be activated initially")
    
    TestHelpers.handStates.right.gripActive = true
    actors:Update(TestHelpers.mockEngine)
    rightHandFlashLight:Update({}, {})
    AssertEquals(rightHandFlashLight.isActive, true, "Flashlight gesture should be active when grip is pressed")
    AssertEquals(rightHandFlashLight:JustActivated(), true, "Flashlight gesture should be newly activated")

    rightHandFlashLight:Execute({})
    AssertEquals(Executed, 1, "Flashlight gesture callback should have executed once")

    rightHandFlashLight:Update({}, {})
    rightHandFlashLight:Execute({})
    AssertEquals(Executed, 2, "callback executing irrsepective of gesture state callback should handle this case internally")

    TestHelpers.handStates.right.location.y = 10.0;
    rightHandFlashLight:Update({}, {})
    rightHandFlashLight:Execute({})
    AssertEquals(rightHandFlashLight.isActive, false, "Flashlight gesture should not be active when out of range")
    AssertEquals(rightHandFlashLight:JustDeactivated(), true, "Flashlight gesture should be deactivated when moving out of range")
    AssertEquals(Executed, 3, "callback executing irrsepective of gesture state callback should handle this case internally")

    rightHandFlashLight:Update({}, {})
    rightHandFlashLight:Execute({})
    AssertEquals(Executed, 4, "callback executing irrsepective of gesture state callback should handle this case internally")

    rightHandFlashLight:SetExecutionCallback(nil) -- Clear the callback to avoid side effects in subsequent tests
    return true
end)
