using ArcGIS.Core.CIM;
using ArcGIS.Core.Data;
using ArcGIS.Core.Geometry;
using ArcGIS.Desktop.Core;
using ArcGIS.Desktop.Core.Geoprocessing;
using ArcGIS.Desktop.Framework;
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
    internal class BufferButton : Button
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

                // Get selected feature layer
                var selectedLayer = mapView.GetSelectedLayers()
                    .OfType<FeatureLayer>()
                    .FirstOrDefault();

                if (selectedLayer == null)
                {
                    MessageBox.Show("Please select a feature layer in the Contents pane.", "Buffer Tool");
                    return;
                }

                // Check if layer has features
                var layerHasFeatures = await QueuedTask.Run(() =>
                {
                    using (var table = selectedLayer.GetTable())
                    {
                        return table.GetCount() > 0;
                    }
                });

                if (!layerHasFeatures)
                {
                    MessageBox.Show($"The selected layer '{selectedLayer.Name}' has no features.", "Buffer Tool");
                    return;
                }

                // Show progress dialog
                var progDialog = new ProgressDialog("Creating buffer...", "Cancel", false);
                var progSource = new CancelableProgressorSource(progDialog);

                // Execute buffer operation
                await QueuedTask.Run(async () =>
                {
                    try
                    {
                        // Define buffer parameters
                        string toolName = "analysis.Buffer";
                        string outputPath = System.IO.Path.Combine(
                            Project.Current.DefaultGeodatabasePath,
                            $"{selectedLayer.Name}_Buffer_{DateTime.Now:yyyyMMddHHmmss}");

                        // Buffer distance - can be customized
                        string bufferDistance = "100 Meters";

                        // Create value array for GP tool
                        var values = Geoprocessing.MakeValueArray(new object[] {
                            selectedLayer,              // in_features
                            outputPath,                 // out_feature_class
                            bufferDistance,             // buffer_distance_or_field
                            "FULL",                     // line_side
                            "ROUND",                    // line_end_type
                            "NONE",                     // dissolve_option
                            null,                       // dissolve_field
                            "PLANAR"                    // method
                        });

                        // Set environment
                        var env = Geoprocessing.MakeEnvironmentArray(overwriteoutput: true);

                        // Execute the buffer tool
                        var gpResult = await Geoprocessing.ExecuteToolAsync(
                            toolName,
                            values,
                            env,
                            null,
                            null,
                            GPExecuteToolFlags.AddOutputsToMap);

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
                                MessageBox.Show("Buffer operation failed. Check parameters.");
                            }
                        }
                        else
                        {
                            MessageBox.Show($"Buffer created successfully!\nOutput: {outputPath}");
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"Error in buffer operation: {ex.Message}", "Buffer Tool Error");
                    }
                }, progSource.Progressor);

                progDialog.Dispose();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error: {ex.Message}", "Buffer Tool Error");
            }
        }
    }
}
