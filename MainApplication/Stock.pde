// Color palletes, images and other stuff

//Old one
color[][] colorList = { // First color is background color
  {#fdfffc, #f44100, #235789, #f1d302, #020100}, 
  {#F3F3F5, #F0A140, #F3842A, #F65429, #127265}, // https://color.adobe.com/418783221695115839577542039351743174672384n-color-theme-11630972/edit/?copy=true&base=2&rule=Custom&selected=0&name=Copy%20of%20418783221695115839577542039351743174672384n&mode=rgb&rgbvalues=0.07058823529411765,0.4470588235294118,0.396078431372549,0.9411764705882353,0.6313725490196078,0.25098039215686274,0.9529411764705882,0.5176470588235295,0.16470588235294117,0.9647058823529412,0.32941176470588235,0.1607843137254902,0.9529411764705882,0.9529411764705882,0.9607843137254902&swatchOrder=0,1,2,3,4
  {#F2EBBF, #F3B562, #F06060, #8CBEB2, #5C4B51}, 
  {#053c5e, #f44100, #a31621, #bfdbf7, #1f7a8c} 
};


//1 version
//color[][] colorList = { // First color is background color
//                      {#F44100,#5f0f40, #9a031e, #fb8b24, #0f4c5c},  // https://color.adobe.com/Copy-of-Copy-of-Copy-of-Phaedra-color-theme-11654352/
//                      {#55dde0,#F44100,#33658a, #2f4858, #f6ae2d},  // https://color.adobe.com/418783221695115839577542039351743174672384n-color-theme-11630972/edit/?copy=true&base=2&rule=Custom&selected=0&name=Copy%20of%20418783221695115839577542039351743174672384n&mode=rgb&rgbvalues=0.07058823529411765,0.4470588235294118,0.396078431372549,0.9411764705882353,0.6313725490196078,0.25098039215686274,0.9529411764705882,0.5176470588235295,0.16470588235294117,0.9647058823529412,0.32941176470588235,0.1607843137254902,0.9529411764705882,0.9529411764705882,0.9607843137254902&swatchOrder=0,1,2,3,4
//                      {#f0f0c9,#F44100, #124e78, #f2bb05, #6e0e0a}  //https://color.adobe.com/vintage-card-color-theme-3165833/edit/?copy=true
//                    };  

//2 version
//color[][] colorList = { // First color is background color
//                     {#cfffb0,#F44100, #5835ee, #fff689, #5998c5},  // https://color.adobe.com/Copy-of-Copy-of-Copy-of-Phaedra-color-theme-11654352/
//                     {#053c5e,#f44100,#a31621, #bfdbf7, #1f7a8c},  // https://color.adobe.com/418783221695115839577542039351743174672384n-color-theme-11630972/edit/?copy=true&base=2&rule=Custom&selected=0&name=Copy%20of%20418783221695115839577542039351743174672384n&mode=rgb&rgbvalues=0.07058823529411765,0.4470588235294118,0.396078431372549,0.9411764705882353,0.6313725490196078,0.25098039215686274,0.9529411764705882,0.5176470588235295,0.16470588235294117,0.9647058823529412,0.32941176470588235,0.1607843137254902,0.9529411764705882,0.9529411764705882,0.9607843137254902&swatchOrder=0,1,2,3,4
//                     {#faedca,#F44100, #f2c078, #c1dbb3, #7ebc89}  //https://color.adobe.com/vintage-card-color-theme-3165833/edit/?copy=true
//                   };  

//                                          //3 version
//color[][] colorList = { // First color is background color
//                     {#f6e8ea,#F44100, #f45b69, #22181c, #5a0001},  // https://color.adobe.com/Copy-of-Copy-of-Copy-of-Phaedra-color-theme-11654352/
//                     {#fdfffc,#f44100,#235789, #f1d302, #020100},  // https://color.adobe.com/418783221695115839577542039351743174672384n-color-theme-11630972/edit/?copy=true&base=2&rule=Custom&selected=0&name=Copy%20of%20418783221695115839577542039351743174672384n&mode=rgb&rgbvalues=0.07058823529411765,0.4470588235294118,0.396078431372549,0.9411764705882353,0.6313725490196078,0.25098039215686274,0.9529411764705882,0.5176470588235295,0.16470588235294117,0.9647058823529412,0.32941176470588235,0.1607843137254902,0.9529411764705882,0.9529411764705882,0.9607843137254902&swatchOrder=0,1,2,3,4
//                     {#FFC971,#F44100, #ff9505, #ffb627, #5998c5}  //https://color.adobe.com/vintage-card-color-theme-3165833/edit/?copy=true
//                   };  


//Set random elements size
float setSize(int a) {
  float res = 0;

  if (a == 0) res = random(20, 60);
  else if (a == 1) res = random(60, 120);
  else if (a == 2) res = random(140, 220);
  else if (a == 3) res = random(220, 400);
  return res;
}


//Set random number of elements depending on it's size
int setCount(int a) {
  int res = 0;
  if (a == 0) res = (int)random(30, 60);
  else if (a == 1) res = (int) random(8, 15);
  else if (a == 2) res = (int) random(2, 6);
  else if (a == 3) res = (int) random(1, 3);
  return res;
}
