const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');
const DistrictMasterModel = require('./DistrictMaster.model');
const DLMasterModel = require('./DLMaster.model');
class IndentMasterModel extends Model {}

IndentMasterModel.init({
    sl_no: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    indent_no: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    dist_id: {
        type: DataTypes.STRING,
        allowNull: false,
        references: {
            model: DistrictMasterModel,
            key: 'dist_id'
        }
    },
    indent_date: {
        type: DataTypes.STRING,
        defaultValue: DataTypes.NOW,
        allowNull: false
    },
    dl_id: {
        type: DataTypes.STRING,
        allowNull: false,
        references: {
            model: DLMasterModel,
            key: 'dl_id'
        }
    },
    fin_year: {
        type: DataTypes.STRING,
        allowNull: false
    },
    status: {
        type: DataTypes.STRING,
        allowNull: false
    },
    items: {
        type: DataTypes.STRING,
        allowNull: false
    },
    indent_ammount: {
        type: DataTypes.NUMBER,
        allowNull: false
    },
}, {
    sequelize,
    modelName: 'IndentMasterModel',
    tableName: 'indent',
    timestamps: false
});


module.exports = IndentMasterModel;