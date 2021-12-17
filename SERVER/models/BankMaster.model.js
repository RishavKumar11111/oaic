const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class BankMasterModel extends Model {}

BankMasterModel.init({
    BankID: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        allowNull: false,
        autoIncrement: true
    },
    BankName: {
        type: DataTypes.STRING,
        allowNull: false
    }
}, {
    sequelize,
    modelName: 'BankMasterModel',
    tableName: 'BankMaster',
    timestamps: false
});


module.exports = BankMasterModel;