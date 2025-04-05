# verify

I would like to create an app which runs on mobile that can track and verify that a user has performed a certain action.

User's can create a verification flow that requires the user takes a certain number of actions.

The actions can have a series of steps and parameters.

- Access to the camera
- Access to the accelerometer
- Access to the microphone
- Access to the location
- Access to nearby devices
- Access to nfc
- Access to bluetooth

It would bundle in mlkit and coremltools to verify the actions.

So the user can create a verification flow that requires the user to take a picture of themself smiling from a given location and the sdk will verify that the user has performed the action.

This can be used for a variety of use cases related to blockchain KYC, 2FA, game verification etc...

## Tech Stack

### Backend

Rust will be used for the backend.

- axum
- oxide_auth
- server_fn (for api)
- sqlx and welds (for sqlite db)
- tokio (for async)
- serde (for serialization)
- log (for logging) and tracing (for tracing)

The database will be sqlite and will be used to store the verification flows and the user's data.

### Frontend

The following integrations will be used for the flutter module.

- flutter_nearby_connections
- flutter_mlkit
- geolocator
- sensors_plus

The initial versions of this tool will bundle all the sdks into the modules. However, in the future it will be useful to split out different features so that developers can pick and choose which features they need.

This means that initially the increased bundle size will be a trade off for the ease of use.

## Development

To ensure that the module is working, an app will be built and included in the repo called reflexes.

The app will present a user a series of actions to perform with increasing difficulty. It is a game that is used to test how the module can be integrated into flutter apps.

In the future we can test how to integrate the module into an expo app and then into a native app.

## Testing

This will be difficult to test since so much of the app requires a real device to test.

Perhaps the best approach is to test the module in the reflexes app and then use the module in other apps. Most of the actions that can be verified will be simulated and ensure that the flow is working.

## hackathon

This project is being built to submit for an AI hackathon I'm participating in.

In order to structure how the project is built, the first part should be to build the reflexes game.

- The game should rely directly on the flutter plugins initially (the action verification functionality can be extracted out later).
- The game should test that mlkit can actually verify the actions like different excercises.

## Ideas

- Verify that a user can answer a question correctly and they aren't using an AI to answer the question. So the verification would track the mouth movement of the user and the voice (words) to deterimine if the answer is correct.

- A fun lie detector.

- Verify in real time that the user is where they say they are. So this is based on geolocation data and they can film the surrounding location to verify that they are at the location.

- Verify that the user has rotated the device to a certain angle using the accelerometer and gyroscope.
