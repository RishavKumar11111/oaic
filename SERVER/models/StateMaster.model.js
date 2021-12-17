const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class StateMasterModel extends Model {}

StateMasterModel.init({
    StateCode: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        allowNull: false
    },
    StateName: {
        type: DataTypes.STRING,
        allowNull: false
    }
}, {
    sequelize,
    modelName: 'StateMasterModel',
    tableName: 'StateMaster',
    timestamps: false
});


module.exports = StateMasterModel;