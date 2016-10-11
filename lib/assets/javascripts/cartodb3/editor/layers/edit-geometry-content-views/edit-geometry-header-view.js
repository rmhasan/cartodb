var CoreView = require('backbone/core-view');
var template = require('./edit-geometry-header.tpl');
var VisTableModel = require('../../../data/visualization-table-model');

module.exports = CoreView.extend({

  initialize: function (opts) {
    if (!opts.layerDefinitionModel) throw new Error('layerDefinitionModel is required');
    if (!opts.configModel) throw new Error('configModel is required');

    this._layerDefinitionModel = opts.layerDefinitionModel;
    this._configModel = opts.configModel;

    this._sourceNode = this._getSourceNode();

    if (this._sourceNode) {
      var tableName = this._sourceNode.get('table_name');
      this._visTableModel = new VisTableModel({
        id: tableName,
        table: {
          name: tableName
        }
      }, {
        configModel: this._configModel
      });
    }
  },

  render: function () {
    this.clearSubViews();

    var tableName = '';
    var url = '';

    if (this._visTableModel) {
      var tableModel = this._visTableModel.getTableModel();
      tableName = tableModel.getUnquotedName();
      url = this._visTableModel && this._visTableModel.datasetURL();
    }

    var nodeDefModel = this._layerDefinitionModel.getAnalysisDefinitionNodeModel();
    var queryGeometryModel = nodeDefModel.queryGeometryModel;

    this.$el.html(
      template({
        isTableSource: !!this._sourceNode,
        url: url,
        tableName: tableName,
        type: queryGeometryModel.get('simple_geom')
      })
    );

    return this;
  },

  _getSourceNode: function () {
    var node = this._layerDefinitionModel.getAnalysisDefinitionNodeModel();
    var source;
    if (node.get('type') === 'source') {
      source = node;
    } else {
      var primarySource = node.getPrimarySource();
      if (primarySource && primarySource.get('type') === 'source') {
        source = primarySource;
      }
    }

    return source;
  }

});