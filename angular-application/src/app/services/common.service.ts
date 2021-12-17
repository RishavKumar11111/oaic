import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class CommonService {

  
  constructor(private http: HttpClient) { }

  get(path: string): any {
    return new Promise(async (resolve, reject) => {
          try {
            let url = environment.server_url + path;
            let callData = await this.http.get(url).toPromise();
            resolve(callData);
          } catch (error) {
            reject(error);
          }
    });
  }
  post(path: string, body: any): any {
    return new Promise(async (resolve, reject) => {
          let url = environment.server_url + path;
          this.http.post(url, body)
            .subscribe(callData => {
              resolve(callData);
            }, error => {
              reject(error);
            });
    });
  }
  directUrlGet(path: string): any {
    return new Promise(async (resolve, reject) => {
          try {
            let url = path;
            let callData = await this.http.get(url, { headers: { 'skip': 'true' } }).toPromise();
            resolve(callData);
          } catch (error) {
            reject(error);
          }
    });
  }
}
