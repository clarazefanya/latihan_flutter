import 'package:flutter/material.dart';
import 'package:latihan_flutter/components/colors.dart';

// TEXTFORMFIELD LOGIN REGISTER
class TextFieldComponent extends StatefulWidget {
  final IconData icon;
  final String hinttext;
  final bool isPassword; //untuk password
  final String? Function(String?)? textFieldVal;
  final TextEditingController textFieldCont;

  const TextFieldComponent({
    super.key,
    required this.icon,
    required this.hinttext,
    this.isPassword = false, //optional hanya utk password
    required this.textFieldCont,
    this.textFieldVal,
  });

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  //obsecure text utk password
  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? obsecure : false,
      controller: widget.textFieldCont,
      validator: widget.textFieldVal,

      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon),
        prefixIconColor: AppColors.borderBrown,

        hintText: widget.hinttext,
        hintStyle: TextStyle(color: const Color(0xFF626566), fontSize: 14),

        //icon hide/show utk password. Jika isPassword true, return icon
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  obsecure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.borderBrown,
                ),
                onPressed: () {
                  setState(() {
                    obsecure = !obsecure;
                  });
                },
              )
            : null,

        // tinggi textfield (padding hintext)
        // contentPadding: EdgeInsets.symmetric(vertical: 17),

        // warna background textfield
        filled: true,
        fillColor: Color(0xFFFFFFFF),

        // border normal
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderBrown, width: 1),
        ),

        // border saat belum fokus
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderBrown, width: 1),
        ),

        // border saat diklik/focus
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderBrown, width: 2),
        ),

        // border saat input salah
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

// BUTTON
class ButtonComponent extends StatefulWidget {
  final String text;
  final Color bgcolor;
  final VoidCallback onPressed;

  const ButtonComponent({
    super.key,
    required this.text,
    required this.bgcolor,
    required this.onPressed,
  });

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.bgcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: AppColors.primaryBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

// APPBAR
class DeebeeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const DeebeeAppbar({super.key, required this.isGameplay});

  final bool isGameplay;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      leading: isGameplay
          ? IconButton(onPressed: () {}, icon: Icon(Icons.menu))
          : null,
      title: Row(
        children: [
          Image.asset(
            "assets/images/logodb-transparan.png",
            width: 32,
            height: 32,
          ),
          SizedBox(width: 8),
          Text(
            "DeeBee",
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryCream,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: AppColors.borderLightBrown),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("1000 XP", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage("assets/images/User Avatar.png"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// COMPONENT LAIN LAGI
