## Dependencies

<p align="center">
	<a class="glightbox" href="../../assets/img/UI_OpacityCutout_Step_7_2.png" data-type="image" data-width="auto" data-height="auto" data-desc-position="bottom">
		<img src="../../assets/img/UI_OpacityCutout_Step_7_2.png" alt="Opacity cutout sample" width="580">
	</a>
</p>

The addon requires two Python packages that are not bundled with Blender:

- **OpenCV** (`opencv-python`) — used for mask processing, morphological cleanup, and contour extraction.
- **PyClipper** (`pyclipper`) — used for polygon union and inward offset operations.

After installation, open the **N-Panel → REV OpacityCutout → Dependencies** section and click **Install Both**. Blender will download and install them via pip. An internet connection is required. Restart Blender once installation completes.

If the install fails, both packages can be installed manually by running the following in a terminal pointed at Blender's Python:

```
python -m pip install opencv-python pyclipper
```