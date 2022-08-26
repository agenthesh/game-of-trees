import 'package:flame/image_composition.dart';

// Constants (size in m)
// - Physics
// const double SCALE = 0.2;
// const double SCALE_WORLD_MULTIPLIER = 100 * SCALE; // meters to centimeters * scaler

// - Size, close to the american pool table (224x112) which is 2:1, we need 16:9
// const double PLAYING_FIELD_HEIGHT = 2.00 * SCALE_WORLD_MULTIPLIER;
// const double PLAYING_FIELD_WIDTH = 1.10 * SCALE_WORLD_MULTIPLIER;

// - Grid size
// const int GRID_VERT_WIDTH = 20;
// const int GRID_VERT_HEIGHT = 11;
// const int GRID_WIDTH = GRID_VERT_WIDTH + 1;
// const int GRID_HEIGHT = GRID_VERT_HEIGHT + 1;
// const double GRID_CELL_GAP = PLAYING_FIELD_WIDTH / GRID_WIDTH;

class UnitSystem {
  final double screenHeightInPixels;
  final double screenWidthInPixels;
  final double playingFieldToScreenRatio;
  final double appBarHeight;

  UnitSystem({
    required this.screenHeightInPixels,
    required this.screenWidthInPixels,
    required this.playingFieldToScreenRatio,
    required this.appBarHeight,
  });

  // Getters

  // change this for grid size/scale
  double get gridWidth => screenWidthInPixels * 0.02;
  double get gridHeight => screenHeightInPixels * 0.016;

  double get pixelsInMeter => screenHeightInPixels / screenHeightInPixels * playingFieldToScreenRatio;
  double get playingFieldHeight => screenHeightInPixels;
  double get playingFieldWidth => screenWidthInPixels;
  double get gridCellGap => ((screenWidthInPixels - (screenWidthInPixels * 0.08)) / gridWidth);
  Vector2 get playingFieldOffset => Vector2(screenWidthInPixels * 0.03, screenHeightInPixels * 0.115);
  Vector2 get activeAreaOffset => playingFieldOffset + Vector2(gridCellGap, gridCellGap);

  // Utility methods
  Vector2 metersToPixels(Vector2 meters) => Vector2(meters.x, meters.y) * pixelsInMeter;

  Vector2 pixelToGrid(Vector2 pixelCoordinates) {
    final dragPixelPosition = pixelCoordinates;
    // print("DRAG PIXEL POSITION: $dragPixelPosition");
    // print("activeAreaOffset: $activeAreaOffset");
    final dragCorrectedPixelPosition =
        dragPixelPosition - (activeAreaOffset + Vector2(0, appBarHeight)); //need to take the app bar size here
    // print("dragCorrectedPixelPosition: $dragCorrectedPixelPosition");
    final dragGridPosition = dragCorrectedPixelPosition / gridCellGap;
    // print("gridCellGap: $gridCellGap");
    // print("dragGridPosition: $dragGridPosition");
    final dragGridPositionRounded =
        Vector2(dragGridPosition.x.round().toDouble(), dragGridPosition.y.round().toDouble()) + Vector2.all(1);

    // print("dragGridPositionRounded: $dragGridPositionRounded");
    // print("----------------------------------------------");
    return dragGridPositionRounded;
  }

  Vector2 gridToPixelFrom({Offset? offset, Vector2? vector}) {
    if (offset == null && vector == null) return Vector2.zero();
    if (offset != null) {
      return gridToPixel(offset.dx, offset.dy);
    } else {
      return gridToPixel(vector!.x, vector.y);
    }
  }

  Vector2 gridToPixel(num x, num y) {
    final result = Vector2.copy(playingFieldOffset);
    result.add(Vector2(x * gridCellGap, y * gridCellGap));
    return result;
  }

  Offset vectorToOffset(Vector2 point) {
    return gridToPixelFrom(vector: point).toOffset();
  }
}
