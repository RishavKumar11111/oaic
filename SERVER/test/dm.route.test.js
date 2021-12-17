const supertest = require('supertest');
const app = require('../app');
const sha256 = require('sha256');
const request = supertest(app)


let token;

beforeAll((done) => {
    request.post('/login')
        .send({
            username: 'DM-KHURDA',
            pass: sha256(sha256('Test@123'))
        })
        .end((err, response) => {
            token = `Bearer ${response.headers["set-cookie"][0].split('accessToken=')[1].split(';')[0]}` 
            done();
        });
});

describe('GET /dm/getAllPaymentApprovals', () => {
    it('Call without finYear', async () => {
            const response = await request.get('/dm/getAllPaymentApprovals')
            .set('Authorization', token)
            expect(response.status).toBe(400)
    });
    it('Call with finYear', async () => {
            const response = await request.get('/dm/getAllPaymentApprovals?fin_year=2021-22')
            .set('Authorization', token)
            expect(response.status).toBe(200)
            expect( Array.isArray(response.body)).toBe(true)
    });
});
// describe('GET /dm/getApprovalDetails', () => {
    // it('Call without approval id', async () => {
    //         const response = await request.get('/dm/getApprovalDetails')
    //         .set('Authorization', token)
    //         expect(response.status).toBe(400)
    // });
    // it('Call with approval id', async () => {
    //         const response = await request.get('/dm/getAllPaymentApprovals?approval_id=11')
    //         .set('Authorization', token)
    //         expect(response.status).toBe(200)
    //         expect( Array.isArray(response.body)).toBe(true)
    // });
// });