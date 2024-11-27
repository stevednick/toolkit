import 'package:flame/components.dart';
import 'package:toolkit/models/asset.dart';

class Tick extends PositionComponent{

  double showTime = 0.7;
  double fadeTime = 0.7;
  late Asset image;
  double displayTime = 3;

  Tick(){
    _loadImage();
  }

  Future<void> _loadImage() async{
    image = Asset.createTick();
    add(image);
  }

  void showTick(){
    displayTime = 0;
  }

  @override
  void update(double dt) {
    displayTime += dt;
    if (displayTime < showTime){
      image.opacity = 1;
    } else if (displayTime < showTime + fadeTime){
      image.opacity = 1 - (displayTime - showTime);
    } else {
      image.opacity = 0;
    }
    super.update(dt);
  }
}