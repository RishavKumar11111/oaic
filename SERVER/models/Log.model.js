const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');
class LogModel extends Model {}

LogModel.init({
    sl_no: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        unique: true,
        primaryKey: true,
        allowNull: false
    },
    date_time: {
        type: DataTypes.DATE,
        allowNull: true
    },
    user_id: {
        type: DataTypes.STRING,
        allowNull: true
    },
    action: {
        type: DataTypes.STRING,
        allowNull: true
    },
    status: {
        type: DataTypes.STRING,
        allowNull: true
    },
    ref_url: {
        type: DataTypes.STRING,
        allowNull: true
    },
    route: {
        type: DataTypes.STRING,
        allowNull: true
    },
    ip: {
        type: DataTypes.STRING,
        allowNull: true
    },
    browser_name: {
        type: DataTypes.STRING,
        allowNull: true
    },
    browser_version: {
        type: DataTypes.STRING,
        allowNull: true
    },
    fin_year: {
        type: DataTypes.STRING,
        allowNull: true
    },
    remark: {
        type: DataTypes.STRING,
        allowNull: true
    }
}, {
    sequelize,
    modelName: 'LogModel',
    tableName: 'log',
    timestamps: false
});


module.exports = LogModel;