import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;



class BlobDetection {
  PImage findConnectedComponents(PImage input, boolean onlyBiggest) {
    // First pass: label the pixels and store labels' equivalences

    int [] labels= new int [input.width*input.height];
    List<TreeSet<Integer>> labelsEquivalences= new ArrayList<TreeSet<Integer>>();
    labelsEquivalences.add(new TreeSet<Integer>()); // For empty 0 label
    int currentLabel=1;
    labelsEquivalences.add(new TreeSet<Integer>()); // To store aquivalent labels of label 1

    PImage img2 = input.copy();
    img2.loadPixels();

    for (int i = 0; i < img2.width*img2.height; i++) {
      // If the pixel is white i.e. selected as in a blob
      if (img2.pixels[i] == color(255) ) {

        // Setting boolean checks and values
        int left = currentLabel; 
        boolean left_b = false;
        int topLeft = currentLabel; 
        boolean topLeft_b = false;
        int top = currentLabel; 
        boolean top_b = false;
        int topRight = currentLabel; 
        boolean topRight_b = false;

        // If current pixel is on upper border
        if (i >= img2.width) { 
          top = labels[i - img2.width]; 
          top_b = labels[i - img2.width] != 0;

          if (i%img2.width != 0) {
            topLeft = labels[i - img2.width -1]; 
            topLeft_b = labels[i - img2.width -1] != 0;
          }

          if (i%(img2.width) != img2.width -1) {
            topRight =  labels[i - img2.width +1]; 
            topRight_b = labels[i - img2.width +1] != 0;
          }
        }

        // If left border
        if (i%img2.width != 0) { 
          left = labels[i-1];  
          left_b = labels[i-1] != 0;
        }

        int minLocal = currentLabel;

        /* if (left_b) minLocal = Math.min(minLocal, left);
         if (topLeft_b) minLocal = Math.min(minLocal, topLeft);
         if (top_b) minLocal = Math.min(minLocal, top);
         if (topRight_b) minLocal = Math.min(minLocal, topRight);
         */
        // Here minLocal is set
        TreeSet<Integer> set = new TreeSet();
        if (left_b) set.add(left);
        if (topLeft_b) set.add(topLeft);
        if (top_b) set.add(top);
        if (topRight_b) set.add(topRight);

        if (!set.isEmpty()) {
          minLocal = set.first();
        }

        TreeSet<Integer> addSet= new TreeSet();
        addSet.addAll(set);
        for (int a= labelsEquivalences.size()-1; a>=0; a--) {
          for (int num : set) {
            if (labelsEquivalences.get(a).contains(num)) {
              addSet.addAll(labelsEquivalences.get(a));
              labelsEquivalences.remove(a);
              --a;
            }
          }
        }


        labelsEquivalences.add(addSet);

        if (minLocal == currentLabel) {
          currentLabel++;
        }
        labels[i] = minLocal;
      }
    }

    // Second pass: re-label the pixels by their equivalent class
    // if onlyBiggest==true, count the number of pixels for each label

    int[] counting_list = new int[labelsEquivalences.size()];
    int max_label_count = 0;
    int max_label = 0;

    for (int i = 0; i < img2.width*img2.height; i++) {
      if (labels[i] != 0) {
        for (TreeSet<Integer> eqclass : labelsEquivalences) {
          if (eqclass.contains(labels[i])) {
            labels[i] = eqclass.first() ;
            if (onlyBiggest) {
              counting_list[labels[i]]++;
              if (counting_list[labels[i]] > max_label_count) { 
                max_label = labels[i]; 
                max_label_count = counting_list[labels[i]];
              }
            }
          }
        }
      }
    }

  

    // Finally,
    // if onlyBiggest==false, output an image with each blob colored in one uniform color
    // if onlyBiggest==true, output an image with the biggest blob colored in white and the others in black

    if (onlyBiggest) {
      for (int i = 0; i < img2.width*img2.height; i++) {
        if (labels[i] == max_label) img2.pixels[i] = color(255);
        else img2.pixels[i] = color(0);
      }
    } else {
      color[] color_table = new color[labelsEquivalences.size()];

      for (int i = 0; i < img2.width*img2.height; i++) {
        if (labels[i] != 0) {
          if (color_table[labels[i]] == 0) color_table[labels[i]] = color(random(255), random(255), random(255));

          img2.pixels[i] = color_table[labels[i]];
        }
      }
    }

    img2.updatePixels();
    return img2;
  }
}
