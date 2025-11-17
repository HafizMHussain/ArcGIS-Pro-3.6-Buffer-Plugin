using ArcGIS.Core.Geometry;
using ArcGIS.Desktop.Core;
using ArcGIS.Desktop.Core.Geoprocessing;
using ArcGIS.Desktop.Framework.Contracts;
using ArcGIS.Desktop.Framework.Dialogs;
using ArcGIS.Desktop.Framework.Threading.Tasks;
using ArcGIS.Desktop.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BufferToolPlugin
{
    internal class BufferTool : Button
    {
        protected override async void OnClick()
        {
            try
            {
                // Get the active map view
                var mapView = MapView.Active;
                if (mapView == null)
                {
                    MessageBox.Show("No active map view found. Please open a map.", "Buffer Tool");
                    return;
                }

                // Get the center point of the current map extent
                MapPoint centerPoint = null;
                await QueuedTask.Run(() =>
                {
                    var extent = mapView.Extent;
                    if (extent != null)
                    {
                        centerPoint = extent.Center;
                    }
                });

                if (centerPoint == null)
                {
                    MessageBox.Show("Could not get map center point.", "Buffer Tool");
                    return;
                }

                // Default buffer distance in meters
                double bufferDistanceMeters = 100.0;

                // Execute buffer operation on background thread
                await QueuedTask.Run(async () =>
                {
                    try
                    {
                        // Create output feature class path
                        var outputPath = System.IO.Path.Combine(
                            Project.Current.DefaultGeodatabasePath,
                            $"BufferOutput_{DateTime.Now:yyyyMMddHHmmss}");

                        // Create buffer using geometry engine
                        var bufferedGeometry = GeometryEngine.Instance.Buffer(centerPoint, bufferDistanceMeters);

                        if (bufferedGeometry == null)
                        {
                            MessageBox.Show("Buffer geometry creation failed.");
                            return;
                        }

                        // Use geoprocessing to create a feature class with the buffer
                        // Create temporary in-memory feature class first, then buffer it
                        var tempFeatureClass = System.IO.Path.Combine(
                            Project.Current.DefaultGeodatabasePath,
                            $"TempPoint_{DateTime.Now:yyyyMMddHHmmss}");

                        // Create point feature class
                        var createFCParams = Geoprocessing.MakeValueArray(
                            Project.Current.DefaultGeodatabasePath,
                            $"TempPoint_{DateTime.Now:yyyyMMddHHmmss}",
                            "POINT",
                            null,
                            "DISABLED",
                            "DISABLED",
                            centerPoint.SpatialReference
                        );

                        var createResult = await Geoprocessing.ExecuteToolAsync(
                            "management.CreateFeatureclass",
                            createFCParams,
                            null,
                            null,
                            null,
                            GPExecuteToolFlags.Default);

                        if (createResult.IsFailed)
                        {
                            MessageBox.Show("Failed to create temporary feature class.");
                            return;
                        }

                        // Now buffer the point
                        var bufferParams = Geoprocessing.MakeValueArray(
                            tempFeatureClass,
                            outputPath,
                            $"{bufferDistanceMeters} Meters",
                            "FULL",
                            "ROUND",
                            "NONE",
                            null,
                            "PLANAR"
                        );

                        var gpResult = await Geoprocessing.ExecuteToolAsync(
                            "analysis.Buffer",
                            bufferParams,
                            null,
                            null,
                            null,
                            GPExecuteToolFlags.AddOutputsToMap);

                        // Clean up temp feature class
                        await Geoprocessing.ExecuteToolAsync(
                            "management.Delete",
                            Geoprocessing.MakeValueArray(tempFeatureClass),
                            null,
                            null,
                            null,
                            GPExecuteToolFlags.Default);

                        // Check result
                        if (gpResult.IsFailed)
                        {
                            if (gpResult.Messages.Count() > 0)
                            {
                                Geoprocessing.ShowMessageBox(gpResult.Messages, "Buffer Tool Error",
                                    GPMessageBoxStyle.Error);
                            }
                            else
                            {
                                MessageBox.Show("Buffer operation failed.");
                            }
                        }
                        else
                        {
                            MessageBox.Show($"Buffer created successfully at map center!\nOutput: {outputPath}");
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"Error in buffer operation: {ex.Message}", "Buffer Tool Error");
                    }
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error creating buffer: {ex.Message}", "Buffer Tool Error");
            }
        }
    }
}
