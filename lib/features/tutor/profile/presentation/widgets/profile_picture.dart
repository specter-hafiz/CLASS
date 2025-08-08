import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/service/shared_pref/shared_pref.dart';
import 'package:class_app/core/utilities/dependency_injection.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  String? storedImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfilePic();
  }

  Future<void> _loadProfilePic() async {
    final user = await sl<SharedPrefService>().getUser();
    if (user != null && user.imageUrl.isNotEmpty) {
      setState(() {
        storedImageUrl = user.imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final double avatarSize =
        SizeConfig.orientation(context) == Orientation.portrait
            ? SizeConfig.screenWidth! * 0.4
            : SizeConfig.screenWidth! * 0.2;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final imageWidget = () {
          if (state is UploadingProfileImage) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UploadProfileImageSuccess && state.url != null) {
            return _networkImage(state.url!, avatarSize);
          } else if (storedImageUrl != null && storedImageUrl!.isNotEmpty) {
            return _networkImage(storedImageUrl!, avatarSize);
          } else {
            return _defaultAvatar(avatarSize);
          }
        }();

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: avatarSize + 12,
                height: avatarSize + 12,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(whiteColor),
                  border: Border.all(color: Color(blueColor), width: 2),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(child: imageWidget),
              ),
              Positioned(
                bottom: 0,
                right: MediaQuery.of(context).size.width * 0.3 * 0.1,
                child: IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Color(blueColor)),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) {
                      context.read<AuthBloc>().add(
                        UploadProfileImageRequested(picked.path),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _defaultAvatar(double size) {
    return Image.asset(
      'assets/images/image.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  Widget _networkImage(String url, double size) {
    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _defaultAvatar(size),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
