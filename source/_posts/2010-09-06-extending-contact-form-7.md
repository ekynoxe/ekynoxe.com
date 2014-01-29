---
title: Extending contact form 7
author: Matt
layout: post
categories:
  - wordpress
tags:
  - contact form 7
  - php
  - plugin
  - wordpress
---
My latest client requested a &#8220;careers&#8221; section on his website, with the possibility to apply to a particular job offer directly from the description page. A form should be displayed on this page, that simply sends an email to the company&#8217;s careers department.

As I developed the website using WordPress and a custom theme, I dug in the excellent [contact form 7][1] plugin and created easily my custom forms.<!--more-->

<p class="attachement"><img src="{{ "cf7-hpt.png" | image_path | cdn }}" alt="contact form 7 extra option" /></p>

An obvious requirement: if the careers department receives an email sent from a form on the website, it should contain the job title or reference.
However, there is nothing in contact form 7 that allows you to include out of the box such a reference that could be a post custom field or the title of the page.

So I created my own contact form 7 custom input that adds a hidden input field containing the page title &#8211; which in my case contains the job description on a position page.

Once you have added the required code, you should see the directly in the generator drop down menu when creating a form, and the syntax to use in your form is as simple as the other tags used by contact form 7:

<pre>[pagetitle field_name]</pre>

To add support for a hidden page title, simply add a file named *pagetitle.php* in the contact form 7 *modules* directory:

## contact-form-7 >modules > pagetitle.php

<pre class="brush: php; title: ; notranslate" title="">
&lt;?php
/**
** A base module for [hidden page title]
**/

// Shortcode handler

wpcf7_add_shortcode( 'pagetitle', 'wpcf7_pagetitle_shortcode_handler', true );

function wpcf7_pagetitle_shortcode_handler( $tag ) {
	if ( ! is_array( $tag ) )
		return '';

	$name = $tag['name'];

	$options = (array) $tag['options'];
	$values = (array) $tag['values'];

	$atts = '';
	$id_att = '';

	$class_att .= ' wpcf7-pagetitle';

	foreach ( $options as $option ) {
		if ( preg_match( '%^id:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$id_att = $matches[1];
		}
	}

	if ( $id_att )
		$atts .= ' id="' . trim( $id_att ) . '"';

	global $wp_query;
	$thePostTitle = $wp_query-&gt;post-&gt;post_title;

	$value = $thePostTitle;

	$html = '&lt;input name="'.$name.'" type="hidden" value="' . esc_attr( $value ) . '"' . $atts . ' /&gt;';

	return $html;
}

// Tag generator

add_action( 'admin_init', 'wpcf7_add_tag_generator_pagetitle', 50 );

function wpcf7_add_tag_generator_pagetitle() {
	wpcf7_add_tag_generator( 'pagetitle', __( 'Hidden page title', 'wpcf7' ),
		'wpcf7-tg-pane-pagetitle', 'wpcf7_tg_pane_pagetitle' );
}

function wpcf7_tg_pane_pagetitle( &amp;$contact_form ) {
? &gt;
&lt;div id="wpcf7-tg-pane-pagetitle" class="hidden"&gt;
&lt;form action=""&gt;
&lt;table&gt;
&lt;tr&gt;&lt;td&gt;&lt;?php echo esc_html( __( 'Name', 'wpcf7' ) ); ?&gt;&lt;br /&gt;&lt;input type="text" name="name" class="tg-name oneline" /&gt;&lt;/td&gt;&lt;td&gt;&lt;/td&gt;&lt;/tr&gt;
&lt;/table&gt;

&lt;table&gt;
&lt;tr&gt;
&lt;td&gt;&lt;code&gt;id&lt;/code&gt; (&lt;?php echo esc_html( __( 'optional', 'wpcf7' ) ); ?&gt;)&lt;br /&gt;
&lt;input type="text" name="id" class="idvalue oneline option" /&gt;&lt;/td&gt;

&lt;td&gt;&lt;code&gt;class&lt;/code&gt; (&lt;?php echo esc_html( __( 'optional', 'wpcf7' ) ); ?&gt;)&lt;br /&gt;
&lt;input type="text" name="class" class="classvalue oneline option" /&gt;&lt;/td&gt;
&lt;/tr&gt;

&lt;/table&gt;

&lt;div class="tg-tag"&gt;&lt;?php echo esc_html( __( "Copy this code and paste it into the form left.", 'wpcf7' ) ); ?&gt;&lt;br /&gt;&lt;input type="text" name="pagetitle" class="tag" readonly="readonly" onfocus="this.select()" /&gt;&lt;/div&gt;

&lt;div class="tg-mail-tag"&gt;&lt;?php echo esc_html( __( "And, put this code into the File Attachments field below.", 'wpcf7' ) ); ?&gt;&lt;br /&gt;&lt;span class="arrow"&gt;&#11015;&lt;/span&gt;&nbsp;&lt;input type="text" class="mail-tag" readonly="readonly" onfocus="this.select()" /&gt;&lt;/div&gt;
&lt;/form&gt;
&lt;/div&gt;
&lt;?php
}

?&gt;
</pre>

Enjoy!

 [1]: http://wordpress.org/extend/plugins/contact-form-7/