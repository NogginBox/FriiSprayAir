﻿/*
 * This is an Open Source Project.
 * @see http://www.friispray.co.uk/
 * @author Richard Garside [http://www.richardsprojects.co.uk/]
 * Copyright 2009 Richard Garside, Stuart Childs & Dave Lynch (The Jam Jar Collective)
 * @license GNU General Purpose License [http://creativecommons.org/licenses/GPL/2.0/]
 *
 * Checkin version: $Id$
 *
 * This file is part of FriiSpray.
 *
 * FriiSpray is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * FriiSpray is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with FriiSpray.  If not, see <http://www.gnu.org/licenses/>.
 */
 
package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.filesystem.*; // for saving images
	import flash.net.FileFilter;
	import flash.utils.ByteArray; // For saving
	import brush.Brush;
	
	/**
	 * A class to help load images chosen by the user
	 */
	public class UserImageLoader
	{
		// Private Properties:
		private var m_activeBrush:Brush;
		private var m_canvas:MovieClip;
		private var m_imageLoader:Loader;
		private var m_paintDepth:int = 1;
	
		/**
		 * Constructor
		 */
		public function UserImageLoader(canvas:MovieClip)
		{
			m_canvas = canvas;
		}
	
		/**
		 * Event handler: The user has selected a new file to be the background image
		 *
		 * @param ev Event object containing event details.
		 */
		private function onOpenImage(event:Event):void
		{
			// Clear the screen
			m_activeBrush.ClearCanvass();
			if(m_imageLoader != null) {
				// Remove old background image
				m_canvas.removeChild(m_imageLoader);
			}
			
			// Load bytes from image file
			var imageFilestream:FileStream = new FileStream();
			imageFilestream.open(File(event.target), FileMode.READ);
			var imageBytes:ByteArray = new ByteArray();
			imageFilestream.readBytes(imageBytes, 0, imageFilestream.bytesAvailable);
			imageFilestream.close();

			// Convert bytes to bitmap
			m_imageLoader = new Loader();
			m_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			m_imageLoader.loadBytes(imageBytes);
		}
		
		/**
		 * Resizes image when loaded as can't do it untill all data is in object.
		 */
		private function onLoaded(ev:Event):void
		{
			trace("Canvas: (" + m_canvas.width + "," + m_canvas.height + ")");
			// Resize the bitmap
			m_imageLoader.width = m_canvas.width;
			m_imageLoader.height = m_canvas.height;
			m_imageLoader.x = 0;
			m_imageLoader.y = 0;
			m_imageLoader.name = 'UserLoadedImage';
			trace("Image: (" + m_imageLoader.width + "," + m_imageLoader.height + ")");
			
			// Add bitmap to the screen (Adding sooner may cause paper to have wrong dimensions)
			
			trace("Adding at " + (m_paintDepth));
			
			m_canvas.addChildAt(m_imageLoader, m_paintDepth);
			
			trace(m_canvas.name);
		}
		
		/**
		 * Open a file and add it to the canvas
		 */
		public function UserChooseFile(activeBrush:Brush, depth:int = 0):void
		{
			m_activeBrush = activeBrush;
			m_paintDepth = depth;
			
			var imageFile:File = new File();
			var imageFileFilter:FileFilter = new FileFilter("Image", "*.jpg;*.png;*.gif");
			
			try 
			{
				imageFile.browseForOpen("Open background image", [imageFileFilter]);
				imageFile.addEventListener(Event.SELECT, onOpenImage);
			}
			catch (error:Error)
			{
				trace("Failed:", error.message);
			}
		}
	}
}