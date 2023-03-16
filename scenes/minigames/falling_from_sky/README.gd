"""
This is a note from AniMerrill about the art, you can discard this
once you have everything working

I made the following sprites for this game:
	* assets/cloud.png
	* assets/icarus.png
	* assets/sky_traffic.png
	* assets/sky_ui.png

I created the following entities:
	* entities/icarus.tscn
	* entities/sky_traffic/apollo.tscn
	* entities/sky_traffic/pegasus.tscn
	* entities/sky_traffic/phoenix.tscn

Icarus (the player), Pegasus, and the Phoenix should all just be one
animation that plays the entire time they are ready and loaded in the
game. If you do need to fiddle with animations though, Icarus has
"falling" and "RESET" while the others have "fly" and "RESET".

Apollo does not have an animation controller and has a script attached
to him instead. The script is set up so that the only things you should
have to do to control him are set his variable `horse_count` and a function
called `flip()` to switch the direction he is facing. When you update
`horse_count` the script will automatically update the horse sprites as
well as randomize their animations somewhat.

Have fun.
"""

