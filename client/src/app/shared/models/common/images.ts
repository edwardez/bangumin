import {Serializable} from '../Serializable';

export class Images implements Serializable<Images> {

  /** example: http://lain.bgm.tv/pic/cover/l/c2/0a/12_24O6L.jpg */
  large?: string;
  /** example: http://lain.bgm.tv/pic/cover/c/c2/0a/12_24O6L.jpg */
  common?: string;
  /** example: http://lain.bgm.tv/pic/cover/m/c2/0a/12_24O6L.jpg */
  medium?: string;
  /** example: http://lain.bgm.tv/pic/cover/s/c2/0a/12_24O6L.jpg */
  small?: string;
  /** example: http://lain.bgm.tv/pic/cover/g/c2/0a/12_24O6L.jpg */
  grid?: string;

  deserialize(input) {
    this.large = input.large.replace(/^http:/, 'https:');
    this.common = input.common.replace(/^http:/, 'https:');
    this.medium = input.medium.replace(/^http:/, 'https:');
    this.small = input.small.replace(/^http:/, 'https:');
    return this;
  }

}