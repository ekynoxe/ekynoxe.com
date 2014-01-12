---
title: Create a deep space background in photoshop
author: Matt
layout: post
categories:
  - design
  - photoshop
tags:
  - design
  - photoshop
  - texture
---

<p class="attachement"><img src="{{ "intro.jpg" | image_path | cdn }}" alt="a deep space background" /></p>

This tutorial will guide you through the creation of a crisp, textured background image with a deep space feeling for your latest website or your desktop.

<!--more-->

## Step 1. Where it all begins.

In Photoshop, create a new document (Ctrl+N) of 1020px by 1300px. Then fill the background layer with the Gradient Tool (G) by drawing a gradient #34383c to #6c6c6c to #090b0a from the top to the bottom of your document. The colors cursor positions are respectively: 0%, 30% and 70%

<p class="attachement"><span><img src="{{ "2.jpg" | image_path | cdn }}" alt="Gradient colors" /><span>Gradient colors</span></span></p>

<p class="attachement"><span><img src="{{ "3.jpg" | image_path | cdn }}" alt="Gradient settings" /><span>Gradient settings</span></span></p>

## Step 2. Create some clouds

Create a new layer, then set your foreground and background colors to #f1f1f1 and #454545 respectively. Then add some clouds by selecting Filter > render > clouds. Then set the blending mode of this layer to ioerlay, and it&#8217;s opacity to 11%.

<p class="attachement"><span><img src="{{ "clouds1.jpg" | image_path | cdn }}" alt="A first layer of clouds" /><span>A first layer of clouds</span></span></p>

<p class="attachement"><span><img src="{{ "clouds1-2.jpg" | image_path | cdn }}" alt="Adjust blending mode and opacity of the clouds" /><span>Adjust blending mode and opacity of the clouds</span></span></p>

## Step 3. Add more clouds

Repeat the previous steps by adding a layer of clouds, changing slightly the different options. Set the foreground color to #e7e7e7 and the background to #404040. Set the blending mode to Overlay again, and use 7% for its opacity.

<p class="attachement"><span><img src="{{ "clouds2.jpg" | image_path | cdn }}" alt="A second, slightly different clouds layer" /><span>A second, slightly different clouds layer</span></span></p>

## Step 4. A few random brush strokes

On a new layer, use the brush tool (B) with a soft angled brush of 30px with 35% opacity and 30% flow to create some random transparent lines mostly vertical on the lighter area. Then set the opacity of that layer to 20~30% to make these highlights very subtle.

<p class="attachement"><span><img src="{{ "7-highlights1.jpg" | image_path | cdn }}" alt="Add some highlights" /><span>Add some highlights</span></span></p>

<p class="attachement"><span><img src="{{ "8-highlights2.jpg" | image_path | cdn }}" alt="Set the opacity to 20% to 30%" /><span>Set the opacity to 20% to 30%</span></span></p>

## Step 5. Add more random strokes

Repeat the same process than step 4 and vary the size and orientation of the shape, but keep an elliptical brush to get some softer edges. Also change the opacity of the layer to keep this second layer even more subtle than the previous one.

Keep things tidy by grouping layers together again.

<p class="attachement"><span><img src="{{ "9-highlights3.jpg" | image_path | cdn }}" alt="Add a second layer of highlights with a different brush" /><span>Add a second layer of highlights with a different brush</span></span></p>

<p class="attachement"><span><img src="{{ "10-highlights4.jpg" | image_path | cdn }}" alt="Set the opacity to 19%" /><span>Set the opacity to 19%</span></span></p>

## Step 6. Add drama&#8230;

In order to bring a deeper and more dramatic feel to the image, we&#8217;ll add a transparent radial gradient layer. This will concentrate most light on the central area of the picture while clipping a bit the edges.

With the Gradient tool (G), add a radial gradient with a soft light blending mode, fading from #000000 to #333333 and respective opacity 100% and 55%. Apply the gradient following roughly  45 degrees direction from the center of the light area to a top corner.

<p class="attachement"><span><img src="{{ "11-radial-gradient.jpg" | image_path | cdn }}" alt="Radial gradient parameters" /><span>Radial gradient parameters</span></span></p>

<p class="attachement"><span><img src="{{ "12-radial-gradient-2.jpg" | image_path | cdn }}" alt="Apply the gradient" /><span>Apply the gradient</span></span></p>

## Step 7. Let there be light!

Right, until now, we&#8217;re navigating in a rather dark corner of some galaxy. We need a bit of light to see where we are! But rather than reinvent the wheel, we&#8217;ll use some amazing brushes available for free. I used a particles and stars brushes set from [brush king][1].

To add these brushes to photoshop, drop them in your brushes folder:

*   */Users/{username}/Library/Application Support/Adobe/Adobe Photoshop CS3/Presets/Brushes* on mac OS X
*   *C:\Program Files\Adobe\Photoshop\Presets\Brushes *on Windows

Then select the brush tool (U) and open the brushes palette, select &#8220;Load Brushes&#8221; from the brushes panel preset picker and navigate to the downloaded and extracted .abr file.

<p class="attachement"><span><img src="{{ "brushes.jpg" | image_path | cdn }}" alt="Open the brushes options to load new brushes" /><span>Open the brushes options to load new brushes</span></span></p>

Then, apply different brushes at your discretion to create star clouds and constellations. Working with opacities, you can achieve a balance of concentration and depth.

I used 4 layers of stars of different opacities (100%, 84%, 64% and 77%) with different brushes applied on them.

<p class="attachement"><span><img src="{{ "13-stars.jpg" | image_path | cdn }}" alt="Different layers with different opacities" /><span>Different layers with different opacities</span></span></p>

<p class="attachement"><span><img src="{{ "14-stars-layers.jpg" | image_path | cdn }}" alt="With 4 layers" /><span>With 4 layers</span></span></p>

## Step 8. Contain the stars

As you can see, the brushes being quite wide, the shape of the patterns are quite visible on the dark region at the top of the page. We&#8217;ll cover this by adding a fade-in gradient over this region to cover the stars. That will also help finishing the textured region in case you want to use the image as a website background and set the color for longer pages.

<p class="attachement"><span><img src="{{ "15-fade-in-gradient.jpg" | image_path | cdn }}" alt="A gradient to fade in the lower star clouds" /><span>A gradient to fade in the lower star clouds</span></span></p>

<p class="attachement"><span><img src="{{ "16-fade-in.jpg" | image_path | cdn }}" alt="Hide the lower star clouds" /><span>Hide the lower star clouds</span></span></p>

## Step 9. Add a texture (optional)

If you want to give your background the impression that it&#8217;s been painted on canvas (yeah, space is always being painted on canvas!) then you can add a nice texture to your image.

Create a layer *under* the gradient fade-in layer, and fill it with the paint bucket tool (G) with white: #ffffff

Then, apply the texturizer filter with 130% scale and 12% relief.

<p class="attachement"><span><img src="{{ "17-texturizer.jpg" | image_path | cdn }}" alt="Apply the texturizer filter" /><span>Apply the texturizer filter</span></span></p>

Change  opacity of the resulting layer to 10% and its blending mode to overlay to obtain a nice horizontal texture on your image.

<p class="attachement"><span><img src="{{ "18-texturizer2.jpg" | image_path | cdn }}" alt="Change blending mode and opacity" /><span>Change blending mode and opacity</span></span></p>

Finally, duplicate that layer, rotate it 90 degrees and you&#8217;ll have something quite close to a canvas texture supporting your deep space image! Group these layers if you&#8217;re picky and you are done!

<p class="attachement"><span><img src="{{ "19-texturizer3.jpg" | image_path | cdn }}" alt="Duplicate the texture to finish your canvas" /><span>Duplicate the texture to finish your canvas</span></span></p>

## Final result

Here is the final .jpeg that you can use directly in your designs, or for reference. It free, but it wouldn&#8217;t be fun if you would not create your own! So go ahead, and show me your creations afterwards!

Thanks for reading.


<p class="attachement"><a href="{{ "deep_space1.jpg" | image_path | cdn }}" title="Final result" rel="lightbox[74]"><img src="{{ "deep_space1_r500.jpg" | image_path | cdn }}" alt="Final result" /><span>Final result</span></a></p>

 [1]: http://www.brushking.eu/35/particles-and-stars-brushes.html