//
#version 3.7;

#include "colors.inc"
#include "skies.inc"
#include "glass.inc"
#include "shapes.inc"
#include "shapes2.inc"


global_settings {
	assumed_gamma 2.2
	max_trace_level 7
}


#declare tick = clock *200/180;
#if (tick = 0 & tick =1)
	#declare tick = 1.2;
#end

camera {
	location <0,30,-18>
	look_at <0,3,20>
	angle 70
}


light_source { <0, 10, 0> color rgb 1}

#declare c = array[8]{
	Red,Green,Blue,Yellow,Cyan,Magenta,Aquamarine,Coral}





sky_sphere {
    S_Cloud4
}
	
#declare num = 30;
#declare mx = array [num];
#declare vx = array [num];


#for (i,0,num-1)
	#declare mx[i] = 0;
	#declare vx[i] = 0;
#end

#declare gp = .8;
//sim
#for (tt , 0 int(tick*180))

	#if (tt/180 >.75)// & abs(mx[0])<.1)
	#else
		#declare mx[0] = (16/*+sin(tt/60*2*pi*2)*6*/) * sin(tt/180*2*pi*4);
	#end
	#for (i,1,num-2)
		//gradius version
		#declare vx[i] = vx[i] + (mx[i-1]-mx[i])*.3;
		
		//string/spring version
		/*#if ( abs(mx[i+1]	-mx[i]) > gp)
			#if (mx[i+1]	-mx[i] > gp)
				#declare eng = pow((mx[i+1]	-mx[i]-gp),2)*.03;
				#declare vx[i] = vx[i]+eng;
				#declare vx[i+1] = vx[i+1]-eng;
			#else
				#declare eng = pow((mx[i+1]	-mx[i]+gp),2)*.03;
				#declare vx[i] = vx[i]-eng;
				#declare vx[i+1] = vx[i+1]+eng;
			#end
		#end
		#if ( abs(mx[i-1]	-mx[i]) >gp)
			#if (mx[i-1]	-mx[i] > gp)
				#declare eng = pow((mx[i-1]	-mx[i]-gp),2)*.03;
				#declare vx[i] = vx[i]+eng;
				#declare vx[i-1] = vx[i-1]-eng;
			#else
				#declare eng = pow((mx[i-1]	-mx[i]+gp),2)*.03;
				#declare vx[i] = vx[i]-eng;
				#declare vx[i-1] = vx[i-1]+eng;
			#end
		#end
		#declare i = i+1;
		*/
	#end

	#for (i,1,num-2)
		#declare mx[i] = mx[i] + vx[i];
		#declare vx[i] = vx[i] *.35;
	#end
#end


//draw
sphere{<mx[0],0,0> , 1
		pigment {Clear}
		finish { F_Glass2 }
		interior {I_Glass2 fade_color color c[0]}
}

#for (i,1,num-2)
	#declare ci = mod(i ,8);
	sphere{<mx[i],0,3*i> , 1
			pigment {Clear}
			finish { F_Glass2 }
			interior {I_Glass2 fade_color color c[ci]}
	}
#end




