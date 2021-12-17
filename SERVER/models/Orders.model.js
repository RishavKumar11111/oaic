const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');
class OrdersModel extends Model {}

OrdersModel.init({
    permit_no: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    permit_issue_date: {
        type: DataTypes.DATE,
        allowNull: false
    },
    permit_validity: {
        type: DataTypes.DATE,
        allowNull: false
    },
    farmer_id: {
        type: DataTypes.STRING,
        allowNull: false
    },
    farmer_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    farmer_father_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    dist_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    block_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    gp_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    village_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    implement: {
        type: DataTypes.STRING,
        allowNull: false
    },
    make: {
        type: DataTypes.STRING,
        allowNull: false
    },
    model: {
        type: DataTypes.STRING,
        allowNull: false
    },
    status: {
        type: DataTypes.STRING,
        allowNull: false
    },
    permit_validity: {
        type: DataTypes.STRING,
        allowNull: false
    },
    permit_issue_date: {
        type: DataTypes.STRING,
        allowNull: false
    },
    fin_year: {
        type: DataTypes.STRING,
        allowNull: false
    },
    dist_id: {
        type: DataTypes.STRING,
        allowNull: false
    },
    engine_no: {
        type: DataTypes.STRING,
        allowNull: false
    },
    chassic_no: {
        type: DataTypes.STRING,
        allowNull: false
    },
    ammount: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    remark: {
        type: DataTypes.STRING,
        allowNull: false
    },
    expected_delivery_date: {
        type: DataTypes.DATE,
        allowNull: false
    },
    delivery_date: {
        type: DataTypes.DATE,
        allowNull: false
    },
    c_fin_year: {
        type: DataTypes.STRING,
        allowNull: false
    },
    date: {
        type: DataTypes.DATE,
        allowNull: false
    },
    system: {
        type: DataTypes.STRING,
        allowNull: false
    },
    paid_amount: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    order_type: {
        type: DataTypes.STRING,
        allowNull: false
    },
    FullCost: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: false
    },
    PendingCost: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: false
    }
}, {
    sequelize,
    modelName: 'OrdersModel',
    tableName: 'orders',
    timestamps: false
});


module.exports = OrdersModel;