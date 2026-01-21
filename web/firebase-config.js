// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyA44JzCfzZ96CAczd5pWZSVM0pcUn4c_uY",
  authDomain: "dr-drive-e1ceb.firebaseapp.com",
  projectId: "dr-drive-e1ceb",
  storageBucket: "dr-drive-e1ceb.firebasestorage.app",
  messagingSenderId: "902970483982",
  appId: "1:902970483982:web:c48494b745b2d6852f635f",
  measurementId: "G-5XDHRJ6K2N"
};

// Initialize Firebase
const app = firebase.initializeApp(firebaseConfig);
const auth = firebase.auth();
const db = firebase.firestore();

// Google Sign-In with GIS
function initializeGoogleSignIn() {
  if (!window.google) {
    console.error('Google Sign-In library not loaded');
    return;
  }
  
  google.accounts.id.initialize({
    client_id: '1067293077128-676gsgj2558pg8094iklij773gg0rkm7.apps.googleusercontent.com',
    callback: handleCredentialResponse,
    auto_select: true,
    cancel_on_tap_outside: false
  });
  
  // Render the Google Sign-In button
  google.accounts.id.renderButton(
    document.getElementById('google-signin-button'),
    { 
      type: 'standard',
      theme: 'outline',
      size: 'large',
      width: 240,
      text: 'signin_with',
      shape: 'rectangular',
      logo_alignment: 'left'
    }
  );
  
  // Prompt the user to sign in
  google.accounts.id.prompt();
}

async function handleCredentialResponse(response) {
  try {
    const credential = firebase.auth.GoogleAuthProvider.credential(response.credential);
    const result = await firebase.auth().signInWithCredential(credential);
    console.log('Google Sign-In successful', result);
    
    // Store the token for future use
    const idToken = await result.user.getIdToken();
    localStorage.setItem('google_token', idToken);
    
    // You can redirect or update UI here
    if (window.flutter_inappwebview) {
      // Send message to Flutter
      window.flutter_inappwebview.callHandler('onGoogleSignIn', {
        idToken: idToken,
        accessToken: response.credential,
        user: {
          displayName: result.user.displayName,
          email: result.user.email,
          photoURL: result.user.photoURL,
          uid: result.user.uid
        }
      });
    }
  } catch (error) {
    console.error('Google Sign-In error', error);
    if (window.flutter_inappwebview) {
      window.flutter_inappwebview.callHandler('onGoogleSignInError', {
        error: error.message || 'Google Sign-In failed'
      });
    }
  }
}

// Initialize Google Sign-In when the page loads
document.addEventListener('DOMContentLoaded', function() {
  // Only initialize if we're not in an iframe (prevents multiple initializations)
  if (window.self === window.top) {
    if (window.google) {
      initializeGoogleSignIn();
    } else {
      // If Google script isn't loaded yet, wait for it
      const checkGoogle = setInterval(() => {
        if (window.google) {
          clearInterval(checkGoogle);
          initializeGoogleSignIn();
        }
      }, 100);
      
      // Set a timeout in case the Google script fails to load
      setTimeout(() => {
        if (!window.google) {
          clearInterval(checkGoogle);
          console.error('Google Sign-In library failed to load');
        }
      }, 5000);
    }
  }
});

// Make auth and db available globally
window.auth = auth;
window.db = db;

// Make auth and db available globally
window.auth = auth;
window.db = db;
