const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class IndentPermitListModel extends Model {}

IndentPermitListModel.init({
    indent_no: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    permit_no: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
}, {
    sequelize,
    modelName: 'IndentPermitListModel',
    tableName: 'indent_desc',
    timestamps: false
});


module.exports = IndentPermitListModel;