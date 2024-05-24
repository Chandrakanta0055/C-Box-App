package com.example.c_box

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        // Save necessary state here
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState != null) {
            // Restore the saved state here
        }
        // Other initialization code
    }
}
