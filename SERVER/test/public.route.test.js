const supertest = require('supertest');
const app = require('../app');
const sha256 = require('sha256');
const request = supertest(app)

let token;

beforeAll((done) => {
    request.post('/login')
        .send({
            username: 'ADMIN',
            pass: sha256(sha256('Test@123'))
        })
        .end((err, response) => {
            token = `Bearer ${response.headers["set-cookie"][0].split('accessToken=')[1].split(';')[0]}` 
            done();
        });
});
describe('GET /signOut', () => {
    it('Sign out user with valid token', async () => {
        const response = await request.get('/signOut')
        .set('Authorization', token)
        expect(response.status).toBe(200)
        expect(response.body).toBe(true)
    });
    it('Sign out user without token', async () => {
        const response = await request.get('/signOut')
        .set('Authorization', '')
        expect(response.status).toBe(401)
        expect(response.body.error.message).toBe('Unauthorized')
    });
    it('Sign out user with wrong token', async () => {
        const response = await request.get('/signOut')
        .set('Authorization', 'qwasadddfereqqqq')
        expect(response.status).toBe(401)
        expect(response.body.error.message).toBe('Unauthorized')
    });
})