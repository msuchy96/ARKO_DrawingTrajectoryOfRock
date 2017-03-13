#include <stdio.h>
#include <stdlib.h>
#include <allegro.h>
#include <math.h>

#include "parabola.h"

int main()

{
	double alpha=45.0, K_parameter=0.00440,Kprim_parameter=0.0001, V_start=90.0,przyciaganie=5.0,alpha2;
	
      	
	
	allegro_init();
	install_keyboard();
	set_color_depth( 24 );
	set_gfx_mode( GFX_AUTODETECT_WINDOWED, 600, 600, 0, 0 );

	BITMAP * obrazek = create_bitmap_ex(8, 600, 600); 
// 8 bitow na kolor - kolorowanie jednego koloruje wszyskto
	

	if( !obrazek)
	{
		set_gfx_mode( GFX_TEXT, 0, 0, 0, 0 );
		allegro_message( "nie mogę załadować obrazu!" );
		allegro_exit();
		return 1;
	}
	
	clear_to_color (obrazek,makecol(0,0,0));
	alpha2=alpha*0.017453;
	parabola(obrazek->line,obrazek->w,obrazek->h,alpha2,K_parameter,Kprim_parameter,V_start,przyciaganie);
	blit(obrazek, screen, 0, 0, 0, 0, obrazek->w, obrazek->h);
	int i = 1;     	
	while( !key[ KEY_ESC ] )
	{
		if(key[KEY_I])
		{
			printf("\n       Instrukcja: \n");
			printf("\n Zwieksz kat - strzalka w gore \n");
			printf("\n Zmniejsz kat - strzalka w dol \n");
			printf("\n Zwieksz predkosc poczatkowa - strzalka w prawo \n");
			printf("\n Zmniejsz predkosc poczatkowa - strzalka w dol \n");
			printf("\n Zwieksz K -  przycisk W\n");
			printf("\n Zmnijesz K -  przycisk S\n");
			printf("\n Zwieksz K' -  przycisk D\n");
			printf("\n Zmniejsz K' -  przycisk A\n");

			
				
		}
		else if(key[KEY_UP])
		{
			if(alpha<57.0)
			{
			alpha+=0.3;
			printf("alpha: %lf \n", alpha);
			alpha2=alpha*0.017453;
			clear_to_color (obrazek,makecol(0,0,0));
			i=1;
			}
 			
			
		}
		else if(key[KEY_DOWN])
		{
			if(alpha>30)
			alpha-=0.3;
			alpha2=alpha*0.017453;
			clear_to_color (obrazek,makecol(0,0,0));
			i=1;
			
		}
		else if(key[KEY_LEFT])
		{
			if(V_start>71)
			V_start-=3.3;
			clear_to_color (obrazek,makecol(0,0,0));
			i=1;
		}
		else if(key[KEY_RIGHT])
		{
			if(V_start<107)
			V_start+=3.3;
			clear_to_color (obrazek,makecol(0,0,0));
			i=1;
			
		}
		else if(key[KEY_W])
		{
			K_parameter+=0.00005;
			clear_to_color (obrazek,makecol(0,0,0));
			i=1;
		}	
		else if(key[KEY_S])
		{
			
			K_parameter-=0.00005;
			clear_to_color (obrazek,makecol(0,0,0));
			i=1;
		}		
			
		else if(key[KEY_A])
		{	
			if(Kprim_parameter>0)
			{
			Kprim_parameter-=0.0001;
			clear_to_color (obrazek,makecol(0,0,0));
			i=1;
			}
		}		
			
		else if(key[KEY_D])
		{
					
			Kprim_parameter+=0.00005;
			clear_to_color (obrazek,makecol(0,0,0));
			i=1;
		}	
		if(i)
		{

		printf("\n       Parametry: \n");
			printf("V_start: %lf \n", V_start);
			printf("Kat: %lf \n", alpha);
			printf("K: %lf \n", K_parameter);
			printf("K': %lf \n", Kprim_parameter);

		parabola(obrazek->line,obrazek->w,obrazek->h,alpha2,K_parameter,Kprim_parameter,V_start,przyciaganie);	
		blit(obrazek, screen, 0, 0, 0, 0, obrazek->w, obrazek->h);
		i=0;		
		}				
		readkey();
	}
	destroy_bitmap(obrazek);
	allegro_exit();
	return 0;
}
