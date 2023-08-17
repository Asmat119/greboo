import 'package:get/get.dart';

class Lang extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        //'hi_IN': {'hello': 'नमस्ते'},
        //'fr_FR': {'hello': 'Bonjour'},
        'en_US': {
          //onBoarding
          'onBoarding_title1':
              'Choose services you want from verified profiles',
          'onBoarding_title2':
              'Get posts daily from businesses you follow to stay updated.',
          'onBoarding_title3':
              'Select Categories of businesses you like to get personalized services',
          //buttons
          'next': 'Next', 'skip': 'Skip',
          'user': 'User',
          'service_provider': 'Service Provider',
          //which services you choose
          'how_would..': 'How would you like to\nJoin?',
          //login
          'user_login': 'User Login',
          'service_provider_login': 'Service Provider Login',
          'get_started': 'Get Started',
          'enter_your..': 'Enter your account details for getting started.',
          'email_address': 'Email Address',
          'email': 'Email',
          'password': 'Password',
          'show': 'Show',
          'hide': 'Hide',
          'forgot_your_password': 'Forgot your password?',
          'check_your_email': 'Check your email',
          'login': 'Login',
          'create_an_account': 'Create an account',
          'continue_as_guest': 'Continue as guest',
          'or': 'or',
          'continue_with..':
              'Continue with social login for more\npersonalized experience.',
          'invalid_email': 'Invalid Email',
          'invalid_password': 'Invalid Password',
          'enter_email': 'Please Enter Email',
          'enter_password': 'Please Enter Password',
          'check_your_connection': 'Check your connection',
          'by_login_in': "By login in, you're agreeing to our ",
          'by_sign_up_in': "By signup, you're agreeing to our ",
          "terms_of_service": "Terms of Services",
          "and": " and ",
          "privacy_policy": "Privacy Policy",
          "report": "Report",
          "report_a_user": "Report a user",
          "please_enter_word": "Please enter word",

          //forgot password
          'forgot_password': 'Forgot Password',
          'enter_your_email..': "Enter your email id to find account",
          'e_mail': 'E-Mail',
          'email_example': 'example@mail.com',
          'password_example': 'XXXXXXXX',
          'submit': 'Submit',
          'save': 'Save',
          'a_link_to..':
              'A link to reset your password has been sent to your registered email account.',
          //register
          'name': 'Name',
          'confirm_password': 'Confirm Password',
          "register": "Register",
          'already_have': 'Already have an account! ',
          'signup': 'Signup',
          //email verify
          'email_verify..':
              'An email with verification link is sent to your email account. Please verify to login.',
          'ok': 'Ok',
          //main screen
          'feeds': 'Feeds',
          'messages': 'Messages',
          'notifications': 'Notifications',
          'profile': 'Profile',
          //home screen
          'change': 'Change',
          'business_categories': 'Business Categories',
          'view_all': 'View All',
          'see_all': 'See more',
          'see_less': 'See Less',
          'like_error':
              "Hey, You can't post & comment on news feeds until your profile is verified",
          'go_to_profile': "Go to Profile",
          'view_profile': 'View Profile',
          'just_now': 'Just now',
          'sign_in_sign_up': 'Sign In or Sign Up',
          'please_signup':
              'Please sign up to proceed further. If you are an existing user please login.',

          //create Post
          'create_post': 'Create Post',
          'take_a_photo': 'Take a photo',
          'take_a_video': 'Take a video',
          'what_do_you..': 'What do you want to talk about?',

          'post_msg':
              'Hey, your post has been successfully posted on news feeds.',
          'go_to_home': 'Go To Home',
          'Leave your comments here...': 'Leave your comments here...',
          //business categories
          'apply': 'Apply',
          //post details
          'post_details': 'Post Details',
          'comments': 'Comments',
          'view_all_comments': 'View All Comments',
          'no_comments': ' No Comments',
          'textfieldmsg1': 'Leave your comments here...',
          //business profile
          'business_profile': 'Business Profile',
          'basic_information': 'Basic Information',
          'phone': 'Phone',
          'unverifiedMsg':
              "Hello, your profile is still unverified. As an unverified user you will be able to see posts but not comment or like. Please verify your account for full access.",
          'follow': 'Follow',
          'followed': 'Followed.',
          'unfollowed': 'Unfollowed.',
          'contact': 'Contact',
          'message': 'Message',
          'posts': 'Posts',

          'description': 'Description',
          'website_links': 'Website Links',
          'location': 'Location',
          'availability': 'Availability',
          'open': 'Open',
          'closed': 'Closed',
          'working_hours': 'Working Hours',
          'working_days': 'Working Days',
          'services_offered': 'Services Offered',
          'customer_reviews': 'Customer Reviews',
          'warning': 'Warning',
          'profileUnverified': 'Profile Unverified',
          'unverified': 'Unverified',
          //edit profile business
          'edit_business_profile': 'Edit Business Profile',
          'business_details': 'Business Details',
          'business_name': 'Business Name',
          'business_category': 'Business Category',
          'phone_number': 'Phone Number',
          'add': 'Add',
          'enter_website_url': 'Enter Website Url',
          'cancel': 'Cancel',
          'kindly_add_a_link': 'Kindly add a link',
          //set availability
          'set_availability': 'Set Availability',
          'edit_availability': 'Edit Availability',
          'select_working_days': 'Select Working Days',
          'select_working_hours': 'Select Working Hours',
          'opening_hour': 'Opening Hour',
          'closing_hour': 'Closing Hour',
          'starts': 'Start',
          'end': 'End',
          //add services offered
          'add_services_offered': 'Add Services Offered',
          'name_of_service': 'Name of service',
          'add_more_service': 'Add More Services',
          'kindly_add_name_and_image': "Kindly add name and image",
          'dialogue_msg':
              'Thank you for registering with grebooo. Once admin will verify your business profile, you will be notified.',

          //messsages
          'textfieldmsg2': 'Type here..',
          'no_messages_yet': 'No messages yet',
          //customer review
          'give_feedback': 'Give Feedback',
          'no_reviews_yet': 'No reviews yet',
          //give feedback
          'how_was..': 'How was your experience with',
          'your_feedback..': 'Your feedback matters to us.',
          'write_your..': 'Write your review',
          'upload_photo': 'Upload photo',
          'click_here': 'Click here to upload',
          'submitting_review': 'Thank you for submitting your review.',
          //profile
          'user_name': 'User Name',
          'about_business': 'About Business',
          'settings': 'Settings',
          'followers': 'Followers',
          "following": "Following",

          //edit profile
          'edit_profile': 'Edit Profile',
          'change_image': 'Change Image',

          //settings
          'about_us': 'About Us',
          'terms': 'Terms & Conditions',
          'contact_admin': 'Contact Admin',
          'faqs': 'FAQs',
          'logOut': 'Logout',
          'terms_and_conditions': 'Terms and Conditions',
          'privacy_policy': "Privacy Policy",
          //notification
          "no_notification_yet": 'No notification yet',
          //About Us
          'aboutusdes':
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting,",
          //Terms and Conditions
          'termsandconditiondes':
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting,",
          //Contact Admin
          'how_can_we_help': 'How can we help?',
          'dialog_msg':
              'Thank you for submitting your request. We will surely help you.',
          //validations
          'enter_mobile_number': 'Please enter mobile number',
          'enter_business_name': 'Please enter business name',
          'enter_category': 'Please select category',
          'enter_description': 'Please enter description',
          'enter_location': 'Please enter location',
          'enter_websites': 'Please enter websites',
          'at_least_one_image': 'At least one image is mandatory',
          'password_not_matched': 'Password not matched',
          'please_enter_name': 'Please enter name',
          'please_enter_email': 'Please enter email',
          'please_enter_password': 'Please enter password',
          'please_enter_valid_email': 'Please enter valid email',
          'please_enter_review': 'Please enter review',
          'please_provide_rating': 'Please enter rating',

          //toasts
          'please_select_working_days': 'Please select working days',
          'please_select_working_hours': 'Please select working hours',
          'no_post_found': 'No post found',
          'please_enter_service': 'Please Enter Service',
          'weblink_toast': "You can add max 3 website link",
          ''
              'no_data_found': 'No data found',
          'no_posts_yet': 'No posts yet',
          'press_again_to_close_app': 'Press again to close app',
          'please_enter_a_word': "Please enter a word",
          //
          'today': 'Today',
          'managed_by': 'Managed By',
          'logOutMsg': 'Are you sure want to log out?',
          'logout': 'Log out?',
          'logoutPop': 'Log out',
          'yes': "Yes",
          'no': 'No',

          // appbar text
          'post': 'Post',
          'filter': 'Filter',
          "distance": "Distance",
          "25 miles": "25 miles",
          "1000 miles": "1000 miles",
          "apply": "Apply",
          "clear": "Clear",
          "upload_your_profile_picture_before_your_first_post":
              "Upload your profile \npicture before your first post",
          ////
          "select_image": "Profile image is mandatory to proceed",
        },
      };
}
