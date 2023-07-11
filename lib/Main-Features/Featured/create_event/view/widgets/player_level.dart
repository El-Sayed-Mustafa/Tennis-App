import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SliderCubit extends Cubit<double> {
  SliderCubit() : super(5.0);

  void setSliderValue(double value) {
    emit(value);
  }
}

class RangeSliderWithTooltip extends StatelessWidget {
  const RangeSliderWithTooltip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<SliderCubit, double>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 2.0, left: screenWidth * .13),
                child: Text(
                  'Player level',
                  style: const TextStyle(
                    color: Color(0xFF525252),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  thumbColor: const Color(0xFF1B262C),
                  overlayColor: Colors.black.withOpacity(0.3),
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 16.0),
                  trackHeight: 8.0,
                  activeTrackColor: _getSliderTrackColor(state),
                  inactiveTrackColor: Colors.grey[300],
                ),
                child: Slider(
                  value: state,
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  onChanged: (newValue) {
                    context.read<SliderCubit>().setSliderValue(newValue);
                  },
                  label: state.round().toString(),
                  onChangeEnd: (newValue) {
                    context.read<SliderCubit>().setSliderValue(newValue);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 2.0, left: screenWidth * .05),
                child: Text(
                  'You can set a skill level requirement for players, allowing\nonly those whose skill level matches the requirement\nyou have set to participate.',
                  style: TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Color _getSliderTrackColor(double value) {
    final double fraction = (value - 1) / (10 - 1);
    return Color.lerp(Colors.white, Colors.red, fraction)!;
  }
}
