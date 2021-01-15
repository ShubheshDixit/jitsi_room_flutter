function meeting(parent, roomName, password, subject, userName) {
    console.log("start session " + roomName );
    var domain = "meet.jit.si";
    var interface = {
        DEFAULT_BACKGROUND: '#474747',
        TOOLBAR_BUTTONS: [
            'microphone', 'camera', 'closedcaptions', 'desktop', 'fullscreen',
            'fodeviceselection', 'hangup', 'profile', 'info', 'chat', 'recording',
            'livestreaming', 'etherpad', 'sharedvideo', 'settings', 'raisehand',
            'videoquality', 'filmstrip', 'feedback', 'stats', 'shortcuts',
            'tileview', 'videobackgroundblur', 'download',  'mute-everyone', 'e2ee'
        ],
        SHOW_JITSI_WATERMARK: false,
        SHOW_WATERMARK_FOR_GUESTS: false,
        JITSI_WATERMARK_LINK: '',
        // APP_NAME: 'Cloud Classroom',
        // NATIVE_APP_NAME: 'Cloud Classroom',
        // PROVIDER_NAME: 'Cloud Classroom',
        DEFAULT_REMOTE_DISPLAY_NAME: 'Fellow',
        DEFAULT_LOCAL_DISPLAY_NAME: 'me',
        DISPLAY_WELCOME_FOOTER: false, //Shubh Added
        INVITATION_POWERED_BY: false,
        CLOSE_PAGE_GUEST_HINT: '<div class = "hint-msg"></div>',
        SHOW_PROMOTIONAL_CLOSE_PAGE: false,
        MOBILE_APP_PROMO: false,
        SUPPORT_URL: '',
        SHOW_CHROME_EXTENSION_BANNER: false
    };
    var options = {
        roomName: roomName,
        passwor: password,
        width: "100%",
        height: "100%",
        enableWelcomePage: false,
        interfaceConfigOverwrite: interface,
        parentNode: document.querySelector(parent),
        userInfo: {
        displayName: userName
    }
    }
    var api = new JitsiMeetExternalAPI(domain, options);
    // add password to room
    api.on("passwordRequired", () => {
    api.executeCommand("password", password);
    });
    // hangup call
    api.on('readyToClose', () => {
    });
  }
  
  