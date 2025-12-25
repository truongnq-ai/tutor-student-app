part of '../view/onboarding_page.dart';

typedef _OnboardingItem = ({
  int index,
  String title,
  Widget image,
  List<String> features,
});

List<_OnboardingItem> _getOnboardingItems(BuildContext context) => [
  (
    index: 0,
    title: context.locale.onboarding_learn_flutter_title,
    image: FlutterLogo(size: context.spacing.s200),
    features: [
      context.locale.onboarding_learn_flutter_subtitle,
      context.locale.onboarding_learn_flutter_description,
    ],
  ),
  (
    index: 1,
    title: context.locale.onboarding_join_community_title,
    image: FlutterLogo(size: context.spacing.s200),
    features: [
      context.locale.onboarding_join_community_subtitle,
      context.locale.onboarding_join_community_description,
    ],
  ),
  (
    index: 2,
    title: context.locale.onboarding_build_deploy_title,
    image: FlutterLogo(size: context.spacing.s200),
    features: [
      context.locale.onboarding_build_deploy_subtitle,
      context.locale.onboarding_build_deploy_description,
    ],
  ),
];
