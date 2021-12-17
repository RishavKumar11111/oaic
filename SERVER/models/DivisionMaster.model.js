const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class DivisionMasterModel extends Model {}

DivisionMasterModel.init({
    DivisionID: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    DivisionName: {
        type: DataTypes.STRING,
        allowNull: false
    }
}, {
    sequelize,
    modelName: 'DivisionMasterModel',
    tableName: 'DivisionMaster',
    timestamps: false
});


module.exports = DivisionMasterModel;