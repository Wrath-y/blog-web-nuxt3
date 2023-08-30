<template>
    <div class="big-box">
        <div class="list" v-loading="loading">
            <div style="display: inline;position: absolute; top: 100px;left:0px">
                <ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-1466336567692166"
                    data-ad-slot="5695809452" data-ad-format="auto" data-full-width-responsive="true"></ins>
            </div>
            <div class="content-box">
                <div class="main-content">
                    <template v-for="(item, index) in list" :key="index">
                        <el-card class="post-card">
                            <div class="post-image" :class="{ 'float-right': index % 2 !== 0 }">
                                <img :src="item.image" />
                            </div>
                            <div class="post-con" :class="{ 'float-right': index % 2 == 0 }">
                                <div class="post-date" :class="{ 'text-right': index % 2 == 0 }">
                                    <i class="el-icon-time"></i>
                                    {{ getNowFormatDate(item.create_time) }}
                                </div>
                                <nuxt-link :to="`/article/${item.id}`">
                                    <h3>{{ item.title }}</h3>
                                </nuxt-link>
                                <div class="post-meta" :class="{ 'text-right': index % 2 == 0 }">
                                    <span class="hits">
                                        <i class="el-icon-view"></i>
                                        {{ item.hits }}热度
                                    </span>
                                    <span class="comments" style="margin: 0 10px">
                                        <i class="el-icon-edit"></i>
                                        {{ item.comment_count || 0 }}条评论
                                    </span>
                                    <span class="tags" @click="chooseTag(item.tags)">
                                        <i class="el-icon-document"></i>
                                        {{ item.tags }}
                                    </span>
                                </div>
                                <div class="post-intro">
                                    <p>{{ item.intro }}</p>
                                </div>
                                <div class="post-bottom" :class="{ 'text-right': index % 2 == 0 }">
                                    <nuxt-link :to="`/article/${item.id}`">
                                        <i class="el-icon-more"></i>
                                    </nuxt-link>
                                </div>
                            </div>
                        </el-card>
                    </template>
                </div>
            </div>
            <div style="display: inline;position: absolute; top: 100px; right:0px">
                <ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-1466336567692166"
                    data-ad-slot="5695809452" data-ad-format="auto" data-full-width-responsive="true"></ins>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const last_id = ref(0);
const loading = ref(true)
const list = ref([]);
const page = ref(1)

let hasFetchedData = false
let hasFetchPages = []

const fetchData = async () => {
    loading.value = true
    if (list.value?.length) {
        last_id.value = list.value[list.value.length - 1]?.id;
    }

    const {
        data
    } = await useHttpGet("/api/articles", `/api/articles?last_id=${last_id.value}`, {
    });
    if (data.value) {
        data.value.map((i) => {
            list.value = list.value.filter((j) => {
                return i.id != j.id;
            });
        });
        list.value = [...list.value, ...data.value];
        last_id.value = list?.value[list.value.length - 1]?.id;
    }
    loading.value = false
    hasFetchedData = false
}

const scrolls = async () => {
    if (hasFetchPages.includes(last_id.value)) {
        return
    }
    const viewportHeight = window.innerHeight || document.documentElement.clientHeight;
    const threshold = viewportHeight * 0.8;

    if (!hasFetchedData && document.documentElement.scrollTop > threshold * (page.value)) {
        hasFetchedData = true
        hasFetchPages.push(last_id.value)
        page.value = page.value + 1;
        await fetchData();
    }
}

const getNowFormatDate = (timestamp) => {
    const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hour = date.getHours() < 10 ? `0${date.getHours()}` : date.getHours()
    const minute = date.getMinutes() < 10 ? `0${date.getMinutes()}` : date.getMinutes()
    const second = date.getSeconds() < 10 ? `0${date.getSeconds()}` : date.getSeconds()
    return `${year}-${month}-${day} ${hour}:${minute}:${second}`
}

// const chooseTag = (select_tag) => {
//     list.value = [];
//     last_id.value = 0;
//     tag.value = select_tag;
//     // fetchData();
// }

onMounted(() => {
    window.addEventListener('scroll', scrolls, true);
    googleads()
})

useAsyncData(fetchData)

</script>

<style scoped lang="scss">
.headertop.filter-dot::before {
    background-image: url('https://wrath-blog.oss-cn-shanghai.aliyuncs.com/ico/dot.gif')
}

.headertop {
    position: relative;
    overflow: hidden;
    height: 71vh;
}

.headertop::before {
    content: '';
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: 3;
    background-attachment: fixed;
}

.header-bg-img {
    width: 100%;
}

.trans {
    animation-duration: 1s;
    animation-timing-function: ease;
    animation-delay: 0s;
    animation-iteration-count: 1;
    animation-direction: normal;
    animation-fill-mode: none;
    animation-play-state: running;
}

.list {
    position: relative;
    width: 100%;
    z-index: 9;
    padding-top: 10vh;

    .content-box {
        display: flex;
        justify-content: center;
        background: #fff;
    }

    .main-content {
        .post-card {
            width: 780px;
            height: 300px;
            border-radius: 10px;
            padding: 0;
            margin: 40px 0;

            .post-image {
                display: inline-block;
                width: 429px;
                overflow: hidden;

                img {
                    width: 429px;
                    height: 300px;
                }
            }

            .post-con {
                display: inline-block;
                width: 279px;
                height: 251px;
                padding: 24px 36px;

                .post-date,
                .post-meta {
                    width: 100%;
                    color: #888;
                    font-size: 12px;
                }

                .post-meta {
                    margin-bottom: 15px;

                    span {
                        width: 33.3%;
                    }

                    .tags:hover {
                        color: #e67474;
                        cursor: url(https://gilgamesh-10047150.cos.ap-shanghai.myqcloud.com/ayuda.cur), auto;
                    }
                }

                .post-intro {
                    color: rgba(0, 0, 0, .66);
                    margin-bottom: 15px;

                    p {
                        position: relative;
                        margin: 0;
                        line-height: 30px;
                        font-size: 16px;
                        overflow: hidden;
                        // text-overflow: ellipsis;
                        // display: -webkit-box;
                        // -webkit-line-clamp: 3;
                        // -webkit-box-orient: vertical;
                        height: 87.5px;
                    }

                    p::after {
                        content: ".";
                        font-weight: bold;
                        position: absolute;
                        bottom: 0;
                        right: 0;
                        padding: 0 20px 1px 45px;
                        background: url(https://wrath-blog.oss-cn-shanghai.aliyuncs.com/ico/ellipsis_bg.png) repeat-y;
                    }
                }

                h3 {
                    text-overflow: ellipsis;
                    display: -webkit-box;
                    -webkit-box-orient: vertical;
                    -webkit-line-clamp: 2;
                    overflow: hidden;
                    word-wrap: break-word;
                    margin: 10px 0 14px 0;
                }

                .post-bottom {
                    font-size: 26px;
                    color: rgb(102, 102, 102);

                    a {
                        padding: 10px 0;
                    }
                }
            }
        }

    }
}

.float-right {
    float: right;
}

.text-right {
    text-align: right;
}
</style>
<style lang="scss">
.list {
    .main-content {
        .el-card__body {
            padding: 0;
            height: 300px;
        }
    }
}
</style>

