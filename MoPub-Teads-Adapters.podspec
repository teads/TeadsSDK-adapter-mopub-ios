Pod::Spec.new do |s|

    s.name                      = 'MoPub-Teads-Adapters'
    s.version                   = '4.6.2'
    s.summary                   = "MoPub Adapter for Teads' iOS SDK"
    s.description               = <<-DESC
                                Use this adapter to include MoPub as a demand source in your mediation waterfall
                                DESC
    s.homepage                  = 'https://github.com/teads/TeadsSDK-iOS'
    s.documentation_url         = "https://support.teads.tv/support/solutions/articles/36000165909"
    s.license                   = { :type => 'Copyright', :text => 'Copyright Teads 2020' }
    s.authors                   = { 'Teads' => 'support-sdk@teads.tv'}

    s.source                    = { :git => 'https://github.com/teads/TeadsSDK-adapter-mopub-ios.git', :branch => 'master', :tag => "v#{s.version}"}
    s.platform                  = 'ios'
    s.ios.deployment_target     = '9.0'
    s.static_framework          = true
    s.requires_arc              = true
    s.ios.vendored_frameworks   = 'TeadsMoPubAdapter.framework'
    s.preserve_paths            = 'TeadsMoPubAdapter.framework'
    s.framework                 = 'TeadsMoPubAdapter'

    s.dependency                'TeadsSDK', "#{s.version}"
    s.dependency                'mopub-ios-sdk', '>= 5.5'

end
