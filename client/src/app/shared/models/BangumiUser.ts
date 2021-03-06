import {Serializable} from './Serializable';
import {Avatar} from './common/avatar';
import {BangumiUserRole} from '../enums/bangumi-user-role.enum';
import {RuntimeConstantsService} from '../services/runtime-constants.service';

interface AvatarType {
  large: string;
  medium: string;
  small: string;
}

export class BangumiUser implements Serializable<BangumiUser> {

  user_id: number;
  id: number;
  url: string;
  sign: string;
  avatar: Avatar;
  nickname: string;
  username: string;
  userGroup: BangumiUserRole;


  constructor() {
    this.user_id = RuntimeConstantsService.defaultBangumiUserId;
    this.id = RuntimeConstantsService.defaultBangumiUserId;
    this.avatar = new Avatar();
    this.nickname = '';
    this.username = '';
    this.userGroup = BangumiUserRole.NormalUser;
  }

  // user id could be from id or user_id, if neither of them have a value, then use a empty one
  static getUserId(input) {
    if (!input.id) {
      if (!input.user_id) {
        return RuntimeConstantsService.defaultBangumiUserId;
      }

      return input.user_id;
    }

    return input.id;

  }

  deserialize(input) {
    this.user_id = BangumiUser.getUserId(input);
    this.id = this.user_id;
    this.url = input.url ? input.url.replace(/^http:/, 'https:') : '';
    this.sign = input.sign || '';
    this.avatar = input.avatar === undefined ? new Avatar() : new Avatar().deserialize(input.avatar);
    this.nickname = input.nickname === undefined ? '' : input.nickname;
    this.username = input.username === undefined ? '' : input.username;
    const rawUserGroup = input.user_group || BangumiUserRole.NormalUser;
    this.userGroup =
      RuntimeConstantsService.validUserGroupValues.indexOf(rawUserGroup) !== -1 ? rawUserGroup : BangumiUserRole.NormalUser;
    return this;
  }


}


