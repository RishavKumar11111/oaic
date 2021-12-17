const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class UsersModel extends Model {}

UsersModel.init({
    user_id: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false
    },
    role: {
        type: DataTypes.STRING,
        allowNull: false
    }
}, {
    sequelize,
    modelName: 'UsersModel',
    tableName: 'users',
    timestamps: false
});


module.exports = UsersModel;