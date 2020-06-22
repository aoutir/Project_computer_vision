import java.util.Collections;

List<PVector> hough(PImage edgeImg , int nLines) {
  
  ArrayList<Integer> bestCandidates = new ArrayList<Integer>();

  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f; 
  int minVotes=100; 
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi +1);
  //The max radius is the image diagonal, but it can be also negative
  int rDim = (int) ((sqrt(edgeImg.width*edgeImg.width +
    edgeImg.height*edgeImg.height) * 2) / discretizationStepsR +1);
    
  // our accumulator
  int[] accumulator = new int[phiDim * rDim];
  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  
  float[] Sin = new float[phiDim];
  float[] Cos = new float[phiDim];
  float ang = 0;
  for (int phi = 0; phi < phiDim; ang += discretizationStepsPhi, phi++) {
    // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
    Sin[phi] = (float) (Math.sin(ang) / discretizationStepsR);
    Cos[phi] = (float) (Math.cos(ang)/ discretizationStepsR);
  }

  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
           for (int phi = 0; phi < phiDim; phi++) {
                double r =  x*Cos[phi]+ y*Sin[phi];
                int radius= (int) Math.round(r+rDim/2);
                accumulator[phi * rDim + radius] += 1;
        }
      }
    }
  }
  

 int neighbourhood = 400; 
  ArrayList<PVector> lines=new ArrayList<PVector>(); 
  for (int idx = 0; idx < accumulator.length; idx++) {
    if (accumulator[idx] > minVotes) {
      int max = accumulator[idx]; 
      boolean maxB = true; 
      for (int i = Math.max(0, idx-neighbourhood); i < Math.min(accumulator.length, idx+neighbourhood); i++) {
        if (accumulator[i] > max) {
          maxB = false; 
          i += 2*neighbourhood; 
        }
      }
      if (maxB) bestCandidates.add(idx); 
    }
  }
  
  Collections.sort(bestCandidates, new HoughComparator(accumulator)); 
  
  for (int i = 0; i < Math.min(bestCandidates.size(), nLines); ++i) {
    int accPhi = (int) (bestCandidates.get(i) / (rDim)); 
    int accR = bestCandidates.get(i) - (accPhi) * (rDim); 
    float r = (accR - (rDim) * 0.5f) * discretizationStepsR; 
    float phi = accPhi * discretizationStepsPhi; 
    lines.add(new PVector(r, phi));
  }
  println(lines.size());

  
  return lines;
}
void displaylines(List<PVector> lines, PImage edgeImg){
  for (int idx = 0; idx < lines.size(); idx++) {
    PVector line=lines.get(idx);
    float r = line.x;
    float phi = line.y;
    // Cartesian equation of a line: y = ax + b
    // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
    // => y = 0 : x = r / cos(phi)
    // => x = 0 : y = r / sin(phi)
    // compute the intersection of this line with the 4 borders of
    // the image
    int x0 = 0;
    int y0 = (int) (r / sin(phi));
    int x1 = (int) (r / cos(phi));
    int y1 = 0;
    int x2 = edgeImg.width;
    int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
    int y3 = edgeImg.width;
    int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
    // Finally, plot the lines
    stroke(204, 102, 0);
    if (y0 > 0) {
      if (x1 > 0)
        line(x0, y0, x1, y1);
      else if (y2 > 0)
        line(x0, y0, x2, y2);
      else
        line(x0, y0, x3, y3);
    } else {
      if (x1 > 0) {
        if (y2 > 0)
          line(x1, y1, x2, y2);
        else
          line(x1, y1, x3, y3);
      } else
        line(x2, y2, x3, y3);
    }
  }
}
