# encoding: utf-8

module Carto
  module Api
    class MobileAppPresenter

      def initialize(mobile_app, current_user, options = {})
        @mobile_app = mobile_app
        @options = options
        @current_user = current_user
      end

      def data
        return {} if @mobile_app.nil?
        data = {
          id: @mobile_app.id,
          name: @mobile_app.name,
          description: @mobile_app.description,
          icon_url: @mobile_app.icon_url,
          platform: @mobile_app.platform,
          app_id: @mobile_app.app_id,
          license_key: @mobile_app.license_key,
          monthly_users: @mobile_app.monthly_users
        }

        if @options[:mobile_platforms].present?
          data[:mobile_platforms] = {
            "android": {
              text: "Android",
              available: platform_available?('android', true),
              selected: platform_enabled?('android'),
              legend: "Use package from AndroidManifest.xml. E.g: com.example.mycartoapp."
            },
            "ios": {
              text: "iOS",
              available: platform_available?('ios', true),
              selected: platform_enabled?('ios'),
              legend: "Use Bundle identifier. You can find it in the project properties. E.g: com.example.mycartoapp."
            },
            "xamarin-android": {
              text: "Xamarin Android",
              available: platform_available?('xamarin-android', @current_user.mobile_xamarin),
              selected: platform_enabled?('xamarin-android'),
              legend: "Use package from AndroidManifest.xml. E.g: com.example.mycartoapp."
            },
            "xamarin-ios": {
              text: "Xamarin iOS",
              available: platform_available?('xamarin-ios', @current_user.mobile_xamarin),
              selected: platform_enabled?('xamarin-ios'),
              legend: "Use Bundle identifier. You can find it in the project properties. E.g: com.example.mycartoapp."
            },
            "windows-phone": {
              text: "Windows Phone",
              available: platform_available?('windows-phone', @current_user.mobile_xamarin),
              selected: platform_enabled?('windows-phone'),
              legend: "Use the Package name from Package.appmanifest. E.g: c882d38a-5c09-4994-87f0-89875cdee539."
            }
          }
        end

        if @options[:app_types].present?
          data[:app_types] = {
            "open": {
              text: "Limits based on your CartoDB plan. <a href='#'>Learn more</a>.",
              available: app_type_available?('open', @current_user.open_apps_enabled?),
              selected: app_type_enabled?('open')
            },
            "dev": {
              text: "Limited to 5 users, unlimited feature-wise. <a href='#'>Learn more</a>.",
              available: app_type_available?('dev', true),
              selected: app_type_enabled?('dev')
            },
            "private": {
              text: "Only for enterprise. <a href='#'>Learn more</a>.",
              available: app_type_available?('private', @current_user.private_apps_enabled?),
              selected: app_type_enabled?('private')
            }
          }
        end

        data
      end

      private

      def platform_available?(platform, enabled)
        !platform_enabled?(platform) || enabled == false
      end

      def platform_enabled?(platform)
        @mobile_app.persisted? && @mobile_app.platform == platform
      end

      def app_type_available?(app_type, enabled)
        !app_type_enabled?(app_type) || enabled == false
      end

      def app_type_enabled?(app_type)
        @mobile_app.persisted? && @mobile_app.app_type == app_type
      end
    end
  end
end
